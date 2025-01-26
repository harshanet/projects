import sys
import time
from constants import *
from environment import *
from state import State
from typing import Dict, Tuple
import numpy as np
from collections import deque

#from environment import Environment
"""
solution.py

This file is a template you should use to implement your solution.

You should implement each section below which contains a TODO comment.

COMP3702 2022 Assignment 2 Support Code

"""


class Solver:

    def __init__(self, environment: Environment):
        self.environment = environment
        self.converged = False
        self.states = []
        #
        # TODO: Define any class instance variables you require (e.g. dictionary mapping state to VI value) here.
        #

    @staticmethod
    def testcases_to_attempt():
        """
        Return a list of testcase numbers you want your solution to be evaluated for.
        """
        # TODO: modify below if desired (e.g. disable larger testcases if you're having problems with RAM usage, etc)
        return [1, 2, 3, 4, 5, 6]

    # === Value Iteration ==============================================================================================

    def vi_initialise(self):
        """
        Initialise any variables required before the start of Value Iteration.
        """
        #
        # TODO: Implement any initialisation for Value Iteration (e.g. building a list of states) here. You should not
        #  perform value iteration in this method.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        self.values = self.initialise_states()
        self.policy = dict()  # initialise policy arbitrarily

    def vi_is_converged(self):
        """
        Check if Value Iteration has reached convergence.
        :return: True if converged, False otherwise
        """
        #
        # TODO: Implement code to check if Value Iteration has reached convergence here.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        return self.converged

    def vi_iteration(self):
        """
        Perform a single iteration of Value Iteration (i.e. loop over the state space once).
        """
        #
        # TODO: Implement code to perform a single iteration of Value Iteration here.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        max_diff = 0
        for s in self.values:
            best_q = -float('inf')
            best_a = None
            for a in BEE_ACTIONS:
                total = 0
                for next_state, reward, prob in self.get_transition_outcomes(s, a): # use apply_dynamics somewhere
                    total += prob * (reward + (self.environment.gamma * self.values[next_state]))
                if total > best_q:
                    best_q = total
                    best_a = a
            max_diff = max(max_diff, abs(self.values[s] - best_q))
            self.values[s] = best_q  # In-place update
            self.policy[s] = best_a

        if max_diff < self.environment.epsilon:
            self.converged = True

    def vi_plan_offline(self):
        """
        Plan using Value Iteration.
        """
        # !!! In order to ensure compatibility with tester, you should not modify this method !!!
        self.vi_initialise()
        while True:
            self.vi_iteration()

            # NOTE: vi_iteration is always called before vi_is_converged
            if self.vi_is_converged():
                break

    def vi_get_state_value(self, state: State):
        """
        Retrieve V(s) for the given state.
        :param state: the current state
        :return: V(s)
        """
        #
        # TODO: Implement code to return the value V(s) for the given state (based on your stored VI values) here. If a
        #  value for V(s) has not yet been computed, this function should return 0.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        return self.values.get(state, 0)

    def vi_select_action(self, state: State):
        """
        Retrieve the optimal action for the given state (based on values computed by Value Iteration).
        :param state: the current state
        :return: optimal action for the given state (element of ROBOT_ACTIONS)
        """
        #
        # TODO: Implement code to return the optimal action for the given state (based on your stored VI values) here.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        return self.policy[state]

    # === Policy Iteration =============================================================================================

    def pi_initialise(self):
        """
        Initialise any variables required before the start of Policy Iteration.
        """
        #
        # TODO: Implement any initialisation for Policy Iteration (e.g. building a list of states) here. You should not
        #  perform policy iteration in this method. You should assume an initial policy of always move FORWARDS.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #

        # map from state objects to indices in T/R models and policy
        self.state_indices = {s: i for i, s in enumerate(self.initialise_states())}

        # full transition matrix (P) of dimensionality |S|x|A|x|S| since it's not specific to any one policy. We'll
        # slice out a |S|x|S| matrix from it for each policy evaluation
        self.t_model = np.zeros([len(self.state_indices), len(BEE_ACTIONS), len(self.state_indices)])

        # reward vector (R)
        self.r_model = np.zeros([len(self.state_indices), len(BEE_ACTIONS)])
        for i, s in enumerate(self.state_indices):
            for j, a in enumerate(BEE_ACTIONS):
                for next_state, reward, prob in self.get_transition_outcomes(s, a):
                    # Ensure next_state is valid and in state_indices
                    if next_state not in self.state_indices:
                        raise KeyError(f"Next state {next_state} not found in state_indices")
                    
                    self.t_model[i][j][self.state_indices[next_state]] += prob # fix this
                    self.r_model[i][j] += reward * prob
    
        # lin alg policy (pi), arbitrarily initialise to 0 (UP) for all states
        self.policy = np.zeros([len(self.state_indices)], dtype=np.int64)

        self.converged = False

    def pi_is_converged(self):
        """
        Check if Policy Iteration has reached convergence.
        :return: True if converged, False otherwise
        """
        #
        # TODO: Implement code to check if Policy Iteration has reached convergence here.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        return self.converged

    def pi_iteration(self):
        """
        Perform a single iteration of Policy Iteration (i.e. perform one step of policy evaluation and one step of
        policy improvement).
        """
        #
        # TODO: Implement code to perform a single iteration of Policy Iteration (evaluation + improvement) here.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        v_pi = self.policy_evaluation()
        self.policy_improvement(v_pi)
    
    def policy_evaluation(self):
        # use linear algebra for policy evaluation
        # V^pi = R + gamma T^pi V^pi
        # (I - gamma * T^pi) V^pi = R
        # Ax = b; A = (I - gamma * T^pi),  b = R

        # indices of every state
        state_numbers = np.array(range(len(self.state_indices)))
        # index into t_model to select only entries where a = pi(s)
        t_pi = self.t_model[state_numbers, self.policy]
        # index into r_model to select only entries where a = pi(s)
        r_pi = self.r_model[state_numbers, self.policy]
        # solve for V^pi(s) using linear algebra
        values = np.linalg.solve(np.identity(len(self.state_indices)) - (self.environment.gamma * t_pi), r_pi)
        # convert V^pi(s) vector to dict and return

        return {s: values[i] for i, s in enumerate(self.state_indices)}
        
    
    def policy_improvement(self, values):    
        policy_changed = False

        # loop over each state, and improve the policy using 1-step lookahead and the values from policy_evaluation
        for s in self.state_indices:
            best_q = -float('inf')
            best_a = None
            for a in BEE_ACTIONS:
                total = 0
                for next_state, reward, prob in self.get_transition_outcomes(s, a):
                    total += prob * (reward + (self.environment.gamma * values[next_state]))
                if total > best_q:
                    best_q = total
                    best_a = a
            # update policy with best action
            if self.policy[self.state_indices[s]] != best_a:
                policy_changed = True
                self.policy[self.state_indices[s]] = best_a

        self.converged = not policy_changed

    def pi_plan_offline(self):
        """
        Plan using Policy Iteration.
        """
        # !!! In order to ensure compatibility with tester, you should not modify this method !!!
        self.pi_initialise()
        while True:
            self.pi_iteration()

            # NOTE: pi_iteration is always called before pi_is_converged
            if self.pi_is_converged():
                break

    def pi_select_action(self, state: State):
        """
        Retrieve the optimal action for the given state (based on values computed by Value Iteration).
        :param state: the current state
        :return: optimal action for the given state (element of ROBOT_ACTIONS)
        """
        #
        # TODO: Implement code to return the optimal action for the given state (based on your stored PI policy) here.
        #
        # In order to ensure compatibility with tester, you should avoid adding additional arguments to this function.
        #
        return self.policy[self.state_indices[state]]
    
    # === Helper Methods ===============================================================================================
    #
    #
    # TODO: Add any additional methods here
    #
    #    
    
    def get_transition_outcomes(self, state, action):
        """
        This method assumes (state, action) is a valid combination.

        :param environment: GameEnv instance
        :param state: current state
        :param action: selected action
        :return: list of (next_state, immediate_reward, probability) tuples
        """
        #exited states
        if self.environment.is_solved(state) == True:
            return []
        
        probability_nodriftcwccw_nodouble_move = (1 - self.environment.drift_cw_probs[action] - self.environment.drift_ccw_probs[action]) * (1 - self.environment.double_move_probs[action])
        probability_nodriftcwccw_double_move = (1 - self.environment.drift_cw_probs[action] - self.environment.drift_ccw_probs[action]) * (self.environment.double_move_probs[action])
        probability_driftcw_nodouble_move = (self.environment.drift_cw_probs[action]) * (1 - self.environment.double_move_probs[action])
        probability_driftcw_double_move = (self.environment.drift_cw_probs[action]) * (self.environment.double_move_probs[action])
        probability_driftccw_nodouble_move = (self.environment.drift_ccw_probs[action]) * (1 - self.environment.double_move_probs[action])
        probability_driftccw_double_move = (self.environment.drift_ccw_probs[action]) * (self.environment.double_move_probs[action])

        all_possible_probabilities_per_state_list = [(probability_nodriftcwccw_nodouble_move, [action]), (probability_nodriftcwccw_double_move, [action, action]), 
                                                    (probability_driftcw_nodouble_move, [SPIN_RIGHT, action]), (probability_driftcw_double_move, [SPIN_RIGHT, action, action]), 
                                                    (probability_driftccw_nodouble_move, [SPIN_LEFT, action]), (probability_driftccw_double_move, [SPIN_LEFT, action, action])]

        outcomes = []
        for probability, action_list in all_possible_probabilities_per_state_list:
            new_state = state
            min_reward = 0
            for action in action_list:
                reward, new_state = self.environment.apply_dynamics(new_state, action)
                # use the minimum reward over all movements
                if reward < min_reward:
                    min_reward = reward
            outcomes.append((new_state, min_reward, probability))

        return outcomes
    
    def initialise_states(self):
        frontier = deque([self.environment.get_init_state()])
        visited = set()

        while len(frontier) > 0:
            node = frontier.popleft()

            for action in BEE_ACTIONS:
                next_state = self.environment.apply_dynamics(node, action)[1]
            # iterate over transition outcomes
                if next_state not in visited:
                    frontier.append(next_state)
                    visited.add(next_state)
        return {state: 0 for state in visited} 
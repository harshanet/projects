import sys
from constants import *
from environment import *
from state import State
import heapq
import time

"""
solution.py

This file is a template you should use to implement your solution.

You should implement 

COMP3702 2024 Assignment 1 Support Code
"""

# Similarly structured to the StateNode class in Tutorial 3. This will be used for the both the ucs
# and A* search methods to initalise the frontier, which will later be changed in accordance to the 
# heap functions.
class StateNode:
    def __init__(self, env: Environment, state, parent=None, action=None, path_cost=0):
        self._state = state
        self._parent = parent
        self._action = action
        self._path_cost = path_cost
        self._env = env

    # Successor function the node will use to against the one given.
    def get_successors(self):
        successors = []
        for a in BEE_ACTIONS:
            success, cost, next_state = self._env.perform_action(self._state, a)
            if success:
                successors.append(StateNode(self._env, next_state, self, a, self._path_cost + cost))
        return successors

    # Path function will calculates the cost required to go to the target tile. 
    def get_path(self):
        path = []
        cur = self
        while cur._action is not None:
            path.append(cur._action)
            cur = cur._parent
        path.reverse()
        return path

    # Less than helper method to ensure that the minimum cost is computed accurately and the heuristic
    # implemented is ultimately admissable. 
    def __lt__ (self, second_state: 'StateNode'):
        return self._path_cost < second_state._path_cost
    
    # Additional helper method to demonstrate a string representation of the StateNode.
    def __str__(self):
        return f"StateNode: {self._state} - {self._path_cost}"

class Solver:

    def __init__(self, environment: Environment, loop_counter):
        self.environment = environment
        self.loop_counter = loop_counter

    #=== Uniform Cost Search ==========================================================================================
    def solve_ucs(self):
        """
        Find a path which solves the environment using Uniform Cost Search (UCS).
        :return: path (list of actions, where each action is an element of BEE_ACTIONS)
        """

        #
        #
        # Implement your UCS code here
        #
        # === Important ================================================================================================
        # To ensure your code works correctly with tester, you should include the following line of code in your main
        # search loop:
        #
        # self.loop_counter.inc()
        #
        # e.g.
        # while loop_condition(): // (While exploring frontier)
        #   self.loop_counter.inc()
        #   ...
        #
        # ==============================================================================================================

        frontier = [StateNode(self.environment, self.environment.get_init_state())]
        heapq.heapify(frontier)
        visited = {self.environment.get_init_state(): 0}
        # The following variable is to compute additional information about this algorithm, such that a more 
        # accurate representation is available for number of nodes computed throughout the operation.
        n_expanded = 0
        while len(frontier) > 0:
            # Code required to operate the tests
            self.loop_counter.inc()
            node = heapq.heappop(frontier)

            # Only if solved does will the node compute the path. 
            if self.environment.is_solved(node._state):
                return node.get_path()
            
            # Successors are added to the heap via the node. 
            successors = node.get_successors()
            for s in successors:
                if s._state not in visited.keys() or s._path_cost < visited[s._state]:
                    visited[s._state] = s._path_cost
                    heapq.heappush(frontier, s)
            n_expanded += 1

        # To compute additional information required for Q3. 
        print(f'Visited Nodes: {len(visited)},\t\tExpanded Nodes: {n_expanded},\t\t'
                        f'Nodes in Frontier: {len(frontier)}')
        print(f'Cost of Path (with Costly Moves): {node._path_cost}')
        return None

        # === A* Search ====================================================================================================

    def preprocess_heuristic(self):
        """
        Perform pre-processing (e.g. pre-computing repeatedly used values) necessary for your heuristic,
        """

        #
        #
        # TODO: (Optional) Implement code for any preprocessing required by your heuristic here (if your heuristic
        #  requires preprocessing).
        #
        # If you choose to implement code here, you should call this method from your solve_a_star method (e.g. once at
        # the beginning of your search).
        #
        #

        pass

    def compute_heuristic(self, state):
        """
        Compute a heuristic value h(n) for the given state.
        :param state: given state (GameState object)
        :return a real number h(n)
        """

        #
        #
        # Implement your heuristic function for A* search here.
        #
        # You should call this method from your solve_a_star method (e.g. every time you need to compute a heuristic
        # value for a state).
        #

        minimum_cost = float("inf")
        for tgt in self.environment.target_list:
            # Using casting to calculate the path cost, between Bee and target tile block.
            total_cost = abs(tgt[0] - int(state.BEE_posit[0])) + abs(tgt[1] - int(state.BEE_posit[1]))
            # An admissible heuristic is one that underestimates the true cost. This is to provide an
            # optimal solution.
            if (total_cost < minimum_cost):
                minimum_cost = total_cost
        return minimum_cost

    def solve_a_star(self):
        """
        Find a path which solves the environment using A* search.
        :return: path (list of actions, where each action is an element of BEE_ACTIONS)
        """
        #
        #
        # Implement your A* search code here
        #
        # === Important ================================================================================================
        # To ensure your code works correctly with tester, you should include the following line of code in your main
        # search loop:
        #
        # self.loop_counter.inc()
        #
        # e.g.
        # while loop_condition(): //
        #   self.loop_counter.inc()
        #   ...
        #
        # ==============================================================================================================
        #
        #

        # Frontier is initialised with the compute_heuristic which ideally should compute the ideal path
        # between the bee and it's target through distance and casting calculations. 
        frontier = [(0 + self.compute_heuristic(self.environment.get_init_state()), StateNode(self.environment, self.environment.get_init_state()))]
        
        heapq.heapify(frontier)
        visited = {self.environment.get_init_state(): 0}

        # The following variable is to compute additional information about this algorithm, such that a more 
        # accurate representation is available for number of nodes computed throughout the operation.
        n_expanded = 0
        while len(frontier) > 0:
            # Code required to operate the tests
            self.loop_counter.inc()
            n_expanded += 1
            _, node = heapq.heappop(frontier)

            # Only if solved does will the node compute the path. 
            if self.environment.is_solved(node._state):
                return node.get_path()
            
            # Successors are added to the heap via the node. 
            successors = node.get_successors()
            for s in successors:
                if s._state not in visited.keys() or s._path_cost < visited[s._state]:
                    visited[s._state] = s._path_cost
                    # The heuristic must be rpesent in the total cost computation so that's its
                    # impact is accounted for in the path cost. 
                    heapq.heappush(frontier, (s._path_cost + self.compute_heuristic(s._state), s))
        
        # To compute additional information required for Q3. 
        print(f'Visited Nodes: {len(visited)},\t\tExpanded Nodes: {n_expanded},\t\t'
                        f'Nodes in Frontier: {len(frontier)}')
        print(f'Cost of Path (with Costly Moves): {node._path_cost}')
        
        return None

#     #
#     #
#     # Add any additional methods here
#     #
#     #
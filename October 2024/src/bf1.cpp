/*
Experiment: how fast is enumerating all knight paths from one corner to another?
*/

#include <string>
#include <iostream>
#include <vector>
#include <stack>

using namespace std;

/* "decomposing" a number 0-35 into a grid coordinate */
vector<int> decompose(int x){
	return vector<int>{x%6, x/6};
}
/* "composing" a grid coordinate into a number 0-35. reverse of above */
int compose(vector<int> x){
	return x[0] + 6*x[1];
}

/* from verify.cpp */
int knight_move(vector<int> ref1, vector<int> ref2){
	return abs((ref2[0] - ref1[0]) * (ref2[1] - ref1[1]))==2;
}
void print_stack(stack<int> st){
	stack<int> newstack = st;
	stack<int> dstack;
	while(!newstack.empty()){
		dstack.push(newstack.top());
		newstack.pop();
	}
	while(!dstack.empty()){
		cout << dstack.top() << " ";
		dstack.pop();
	}
}




int main(){
	int i, j;
	int lv, in;
	
	int backtracks = 0;
	int successes = 0;
	
	/* whether each member has been visited */
	bool grid_vis[36];
	/* grid adjacencies */
	vector<int> grid_adjacencies[36];
	
	/* last visisted */
	stack<int> last_visited;
	/* ref for index used to visit last */
	stack<int> indices;
	
	/* populating grid adjacencies, marking visited as false */
	for(i=0; i<36; i++){
		grid_adjacencies[i] = vector<int> {};
		for(j=0; j<36; j++){
			if(knight_move(decompose(i), decompose(j))){
				grid_adjacencies[i].push_back(j);
			}
		}
		grid_vis[i] = false;
	}
	last_visited.push(0);
	indices.push(0);
	grid_vis[0] = true;
	while(!last_visited.empty()){
		lv = last_visited.top();
		in = indices.top();
		if(lv == 35){
			successes++;
			last_visited.pop();
			indices.pop();
			grid_vis[35] = false;
			if(successes % 1000000 == 0){
				cout << successes << " successes: ";
				print_stack(indices);
				cout << endl;
			}
		} else if(in < grid_adjacencies[lv].size() && !grid_vis[grid_adjacencies[lv][in]]){
			/* increment top of indices */
			indices.pop();
			indices.push(in+1);
			
			/* adds new entry to stack */
			last_visited.push(grid_adjacencies[lv][in]);
			indices.push(0);
			grid_vis[grid_adjacencies[lv][in]] = true;
		} else if(in < grid_adjacencies[lv].size()){
			/* this is the case where it's already visited */
			indices.pop();
			indices.push(in+1);
		} else {
			/* backtracking */
			backtracks++;
			grid_vis[lv] = false;
			last_visited.pop();
			indices.pop();
			if(backtracks % 1000000 == 0){
				cout << backtracks << " backtracks: ";
				print_stack(indices);
				cout << endl;
			}
		}
	}
	cout << endl << endl << successes << " successes" << endl << backtracks << " backtracks" << endl;
	
	
}
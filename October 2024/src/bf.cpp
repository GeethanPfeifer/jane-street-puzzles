/*
Takes A,B,C (via command-line arguments) and tries to find a valid solution.
*/

#include <string>
#include <iostream>
#include <vector>
#include <stack>

#define check_succeeded() if(!suc){cout << "FAIL!"; return -1;} 

using namespace std;

/* "decomposing" a number 0-35 into a grid coordinate */
vector<int> decompose(int x){
	return vector<int>{x%6, x/6};
}
/* "composing" a grid coordinate into a number 0-35. reverse of above */
int compose(vector<int> x){
	return x[0] + 6*x[1];
}

/* copied and modified from verify.cpp */
typedef enum Symbols {
	A,
	B,
	C
} Symbols;


/*
6 is top, 1 is bottom.
a is left, f is right.
*/
const Symbols grid_values[36] = {
	A,B,B,C,C,C,
	A,B,B,C,C,C,
	A,A,B,B,C,C,
	A,A,B,B,C,C,
	A,A,A,B,B,C,
	A,A,A,B,B,C
};
vector<int> ref_from_alg(char c1, char c2){
	/* 97 = 'a', 102 = 'f', 49 = '1', 54 = '6'*/
	return vector<int>{c1-97, 54-c2};
}
	
	
void substitute(int grid[36], int av, int bv, int cv){
	int i;
	for(i=0; i<36; i++){
		switch(grid_values[i]){
			case A:
				grid[i] = av;
				break;
			case B:
				grid[i] = bv;
				break;
			case C:
				grid[i] = cv;
				break;
		}
	}
}
int knight_move(vector<int> ref1, vector<int> ref2){
	/* magic */
	return abs((ref2[0] - ref1[0]) * (ref2[1] - ref1[1]))==2;
}
/* end from verify.cpp */

vector<char> alg_from_ref(int i){
	int i1, i2;
	vector<int> dec = decompose(i);
	i1 = dec[0];
	i2 = dec[1];
	return vector<char>{i1+97,54-i2};
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

/* prepends a ',' */
void print_path(stack<int> st){
	stack<int> newstack = st;
	stack<int> dstack;
	vector<char> cv;
	while(!newstack.empty()){
		dstack.push(newstack.top());
		newstack.pop();
	}
	while(!dstack.empty()){
		cv = alg_from_ref(dstack.top());
		cout << "," << cv[0] << cv[1];
		dstack.pop();
	}
}



int main(int argc, char* argv[]){
	int i, j;
	int lv, in, sc, nlv, cof;
	int av, bv, cv;
	bool suc = false;

	/* whether each member has been visited */
	bool grid_vis[36];
	/* grid adjacencies */
	vector<int> grid_adjacencies[36];
	
	int val_grid[36];
	
	/* last visisted */
	stack<int> last_visited;
	/* ref for index used to visit last */
	stack<int> indices;
	/* scores */
	stack<int> scores;
	
	/* cin >> av >> bv >> cv; */
	av = stoi(argv[1]);
	bv = stoi(argv[2]);
	cv = stoi(argv[3]);
	substitute(val_grid, av, bv, cv);
	
	cout << av << "," << bv << "," << cv;
	

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
	
	/* 30 to 5 first */
	last_visited = {};
	indices = {};
	scores = {};
	
	last_visited.push(30);
	indices.push(0);
	scores.push(av);
	grid_vis[30] = true;
	while(!last_visited.empty()){
		lv = last_visited.top();
		in = indices.top();
		sc = scores.top();
		if(lv == 5 && sc == 2024){
			/* escape */
			print_path(last_visited);
			last_visited = {};
			suc = true;
		/* backtracking */
		} else if (lv == 5 || sc >= 2024 || in >= grid_adjacencies[lv].size()){
			grid_vis[lv] = false;
			last_visited.pop();
			indices.pop();
			scores.pop();

		} else if(!grid_vis[nlv = grid_adjacencies[lv][in]]){
			/* increment top of indices */
			indices.pop();
			indices.push(in+1);
			
			/* adds new entry to stack */
			last_visited.push(nlv);
			indices.push(0);
			
			if(val_grid[lv] == (cof = val_grid[nlv])){
				scores.push(sc + cof);
			} else {
				scores.push(sc * cof);
			}
			
			
			grid_vis[nlv] = true;
		} else {
			/* this is the case where it's already visited */
			indices.pop();
			indices.push(in+1);
		}
	}
	check_succeeded();
	suc = false;
	/*
	marking vis as false
	*/
	for(i=0; i<36;i++){
		grid_vis[i] = false;
	}
	
	/* 0 to 35 last */
	last_visited = {};
	indices = {};
	scores = {};
	
	last_visited.push(0);
	indices.push(0);
	scores.push(av);
	grid_vis[0] = true;
	while(!last_visited.empty()){
		lv = last_visited.top();
		in = indices.top();
		sc = scores.top();
		if(lv == 35 && sc == 2024){
			/* escape */
			print_path(last_visited);
			last_visited = {};
			suc = true;
		/* backtracking */
		} else if (lv == 35 || sc >= 2024 || in >= grid_adjacencies[lv].size()){
			grid_vis[lv] = false;
			last_visited.pop();
			indices.pop();
			scores.pop();

		} else if(!grid_vis[nlv = grid_adjacencies[lv][in]]){
			/* increment top of indices */
			indices.pop();
			indices.push(in+1);
			
			/* adds new entry to stack */
			last_visited.push(nlv);
			indices.push(0);
			
			if(val_grid[lv] == (cof = val_grid[nlv])){
				scores.push(sc + cof);
			} else {
				scores.push(sc * cof);
			}
			
			
			grid_vis[nlv] = true;
		} else {
			/* this is the case where it's already visited */
			indices.pop();
			indices.push(in+1);
		}
	}
	check_succeeded();
	
	return 0;
}
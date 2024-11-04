/*
Takes an input (via stdin) and determines it is a valid solution.
*/

#include <string>
#include <iostream>
#include <vector>

#define on_cin_error(s) if(cin.fail()){cout << s << endl; return -1;}
#define read_comma() cin >> comma; if(comma != ','){cout << "not comma separated" << endl; return -1;}
#define read_ref() cin >> c1 >> c2;\
	if(c1 < 97 || c1 > 102 || c2 < 49 || c2 > 54){cout << "invalid square" << endl; return -1;}\
	ref=ref_from_alg(c1,c2);
#define ref_must_be(q1,q2, p) if(ref != vector<int>{q1, q2}){cout << "ref must be " << p << endl; return -1;}
#define must_be_knight_move() if(!knight_move(oref, ref)){cout << "not knight move" << endl; return -1;}
#define general_error(s) {cout << s << endl; return -1;}
#define unvisit_all()	for(i=0; i<6; i++){for(j=0; j<6; j++){vis[i][j] = false;}}
#define visit_ref() if(vis[ref[0]][ref[1]]){cout << "square visited twice " << endl; return -1;}\
	vis[ref[0]][ref[1]] = true;

using namespace std;

typedef enum Symbols {
	A,
	B,
	C
} Symbols;


/*
6 is top, 1 is bottom.
a is left, f is right.
*/
const Symbols grid_values[6][6] =
	{
		{A,B,B,C,C,C},
		{A,B,B,C,C,C},
		{A,A,B,B,C,C},
		{A,A,B,B,C,C},
		{A,A,A,B,B,C},
		{A,A,A,B,B,C}
	};
vector<int> ref_from_alg(char c1, char c2){
	/* 97 = 'a', 102 = 'f', 49 = '1', 54 = '6'*/
	return vector<int>{54-c2, c1-97};
}
	
	
void substitute(int grid[6][6], int av, int bv, int cv){
	int i, j;
	for(i=0; i<6; i++){
		for(j=0; j<6; j++){
			switch(grid_values[i][j]){
				case A:
					grid[i][j] = av;
					break;
				case B:
					grid[i][j] = bv;
					break;
				case C:
					grid[i][j] = cv;
					break;
			}
		}
	}
}
int search(int grid[6][6], vector<int> ref){
	return grid[ref[0]][ref[1]];
}
int knight_move(vector<int> ref1, vector<int> ref2){
	/* magic */
	return abs((ref2[0] - ref1[0]) * (ref2[1] - ref1[1]))==2;
}
int main(){
	int av, bv, cv, score, t, i, j;
	char comma;
	char c1, c2;
	int grid[6][6];
	bool vis[6][6];
	vector<int> ref, oref;
	
	cin >> av;
	on_cin_error("non-int for A");
	read_comma();
	
	cin >> bv;
	on_cin_error("non-int for B");
	if(av == bv){
		general_error("A,B,C must be distinct");
	}
	read_comma();
	
	cin >> cv;
	on_cin_error("non-int for C");
	if(av == cv || bv == cv){
		general_error("A,B,C must be distinct");
	}
	read_comma();
	
	if(av + bv + cv >= 50){
		cout << "warning: A+B+C >= 50" << endl;
	}
	
	substitute(grid, av, bv, cv);
	
	
	unvisit_all();
	
	read_ref();
	visit_ref();
	/* (5,0) corresponds to a1 */
	ref_must_be(5, 0, "a1");
	
	
	score = av;
	while(ref != vector<int>{0,5}){
		read_comma();
		oref = ref;
		read_ref();
		visit_ref();
		
		must_be_knight_move();
		t = search(grid, ref);
		if(t == search(grid, oref)){
			score += t;
		} else {
			score *= t;
		}
	}
	if(score != 2024){
		cout << "score of first trip is " << score << endl;
		return -1;
	}
	read_comma();
	
	unvisit_all();
	
	read_ref();
	visit_ref();
	/* (0,0) corresponds to a6 */
	ref_must_be(0, 0, "a6");
	
	score = av;
	while(ref != vector<int>{5,5}){
		read_comma();
		oref = ref;
		read_ref();
		visit_ref();
		
		must_be_knight_move();
		t = search(grid, ref);
		if(t == search(grid, oref)){
			score += t;
		} else {
			score *= t;
		}
	}
	if(score != 2024){
		cout << "score of second trip is " << score << endl;
		return -1;
	}
	
	cout << "valid" << endl;
	return 0;
	
}
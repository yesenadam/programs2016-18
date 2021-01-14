#include <iostream>
using std::cout;
void FindHColumn(unsigned char col);
const unsigned char X=6, Y=6; // rows and cols in packing i.e. X across by Y down
const unsigned char tot=X*Y;
unsigned char v[tot+1], c=0;
//squares are numbered from v[1] down the columns, from L to R.
//i.e. top square of second column is v[Y+1], below that v[Y+2] etc

inline bool Used(unsigned char ind) { //i.e. to see if v[4]=2 has been used, Used(4) checks if v[1-3]=2
for (unsigned char j=1;j<ind;j++)
	if (v[j]==v[ind]) return true;
return false; //not already used
} 

void Show() {
cout << int(X) << " x " << int(Y) << "\n";
for (unsigned char j=1;j<Y+1;j++){
	for (unsigned char i=1;i<X+1;i++)
		cout << int(v[(i-1)*Y+j]) << " ";
	cout << "\n";
}
cout << "\n";
c++;
}

//inline bool Forbidden (unsigned char w) {
//return (v[w]>tot || Used(w)); 
//} // num is too big or used 

inline bool SetVTestH(unsigned char wh){
v[wh]=v[wh-Y-1]+v[wh-Y]-v[wh-1]; //square wh is BR of a vline. d=a+b-c
return (v[wh]>tot || Used(wh) || (v[wh-Y]+v[wh]<=v[wh+1-Y])); //v[wh] is TR of an hline. is a+b<=c?
} //ie true if too big, already used or TooSmall etc

inline bool SetHTestV(unsigned char wh){
v[wh]=v[wh-Y-1]+v[wh-1]-v[wh-Y];// v[wh] is BR of an hline. set d=a+b-c.
return (v[wh]>tot || Used(wh) || (v[wh]>=v[wh-Y]+v[wh-Y+1])); //v[wh] is TR of a vline, test if c>=a+b
}

inline bool VColFill(unsigned char loc) { //fill column from 2nd num down
for (unsigned char k=1;k<Y;k+=2) {
	if (SetVTestH(loc)) return false;
	if (k+1>Y) break; //reached bottom of column
	if (SetHTestV(loc+1)) return false;
	loc+=2; //do next pair of squares down
}
return true; //success; whole column filled
}

void FindVColumn(unsigned char col) { //i.e. a column with v-line at top - cols 3,5,7 etc
unsigned char x=(col-1)*Y+1;
for (v[x]=1;v[x]<tot+1;v[x]++) {
	if (Used(x)) continue;
	//we have a,b,c of a v-line. (v[x] is c, top right num of an vline). is a+b<=c?
	if (v[x-Y]+v[x-Y+1]<=v[x]) break;//continue; no higher x will work either, go back
	if (!VColFill(x+1)) continue; //if failed, start filling column again from top
	//have now filled column successfully. either have finished or do next column.
	if (col==X) Show(); else FindHColumn(col+1);
}}

inline bool HColFill(unsigned char loc) {
for (unsigned char k=1;k<Y;k+=2) {
	if (SetHTestV(loc)) return false;
	if (k+1>Y) break; //reached bottom of column
	if (SetVTestH(loc+1)) return false;
	loc+=2; //do next pair of squares down
}
return true; //success; whole column filled
}

void FindHColumn(unsigned char col) { //i.e. a column with an h-line at top - cols 2,4,6 etc
unsigned char x=(col-1)*Y+1;
for (v[x]=1;v[x]<tot+1;v[x]++) {
	//we have a,b,c of an h-line. (v[x] is b, TR of an hline). is a+b<=c?
	if (Used(x) || v[x-Y]+v[x]<=v[x-Y+1]) continue;
	if (!HColFill(x+1)) continue; //if failed, start filling column again from top
	if (col==X) Show(); else FindVColumn(col+1);
}}

void FillFirstColumn(unsigned char row) {
for (v[row]=1;v[row]<tot+1;v[row]++) {
	if (Used(row)) continue;
//ok, value is good to use, set next num down or go to next column if finished
if (row==Y) FindHColumn(2); else FillFirstColumn(row+1);
}}

int main (int argc, char * const argv[]) {
cout << "\nSquarePack v1\n";
cout << int(X) << " x " << int(Y) << " packing - " << int(X*Y) << " squares.\n";
for (v[1]=1;v[1]<tot+1;v[1]++) {
	FillFirstColumn(2);
	cout << int(v[1]) << "..\n"; //comment out if dont want progress reports
}
cout << int(c) << " found.\n";
return 0;
}

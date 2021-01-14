NF>0 {
	min=1; #minimum size to label
	if (match($0,"x")) {
		cols=$1;
		rows=$3;
		print "<hr>";
		print "<b>"$0" = "cols*rows" squares</b>";
		print "\\begin{tikzpicture} [scale=0.1]";
		print "[+preamble]";
  		print "\\usepackage{tikz}";
		print "[/preamble]";
		ix=0; iy=0;
		cr=ix;ct=iy;
		for (li=1;li<rows+1;li++) {
			do getline; while(NF<2);
			l[li]=$0;
			print "#line "li" : "$0;
			if (li==1) {
				ct=ct+$1;
			}
			else {cr=rx-$1; ct=by}
			print "\\draw[thick,black] ("cr","ct") rectangle ("cr+$1","ct-$1");";
			if ($1>=min) print "\\node at ("cr+$1/2","ct-$1/2") {\$"$1"\$};";
			rx=cr+$1; #x-pos of BR corner of first shape on line
			lx=cr;
			ty=ct;
			by=ct-$1
			cb=ct-$1; #current bottom edge
			ct=ct; #current top edge
			cr=cr+$1; #current right edge
			for (t=2;t<cols+1;t+=2) {
				#in pairs - hline, vline
				#hline: join at bottom edge:
				newr=cr+$(t);
				newt=cb+$(t);
				print "\\draw[thick,black] ("cr","cb") rectangle ("newr","newt");";
				if ($(t)>=min) print "\\node at ("(cr+newr)/2","(cb+newt)/2") {\$"$(t)"\$};";
				if (t==NF) break; #finished line
				#vline: join at top edge
				nt=t+1; #next t = t+1
				cr=newr+$(nt);
				cb=newt-$(nt);
				print "\\draw[thick,black] ("newr","newt") rectangle ("cr","cb");";
				if ($(nt)>=min) print "\\node at ("(cr+newr)/2","(cb+newt)/2") {\$"$(nt)"\$};";
			}
			li++;
			if (li<rows+1) getline; else break;
			l[li]=$0;
			print "#line "li" : "$0;
			print "\\draw[thick,black] ("lx","by") rectangle ("lx+$1","by-$1");";
			print "\\node at ("lx+$1/2","by-$1/2") {\$"$1"\$};";
			rx=lx+$1; #x-pos of BR corner of first shape on line
			ct=by#iy; #current top edge
			by=by-$1
			cb=by#iy-$1; #current bottom edge
			cr=lx+$1; #current right edge
			for (t=2;t<cols+1;t+=2) {
				#in pairs - hline, vline
				#vline: join at top edge:
				newr=cr+$(t);
				newb=ct-$(t);
				print "\\draw[thick,black] ("cr","ct") rectangle ("newr","newb");";
				print "\\node at ("(cr+newr)/2","(ct+newb)/2") {\$"$(t)"\$};";
				if (t==NF) break; #finished line
				#hline: join at bottom edge
				nt=t+1; #next t = t+1
				cr=newr+$(nt);
				ct=newb+$(nt);
				print "\\draw[thick,black] ("newr","newb") rectangle ("cr","ct");";
				print "\\node at ("(cr+newr)/2","(ct+newb)/2") {\$"$(nt)"\$};";
			}

		}
			print "\\end{tikzpicture}";
			#print "\n";
			for (z=1;z<rows+1;z++) print "[ "l[z]"]";
	}
}
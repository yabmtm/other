awk ' BEGIN{ 
 for(i=0;i<=1000;i++) 
 { 
  if (i <=1 )
  {
   x=0;
   y=1;
   print i;
  }
  else
  {
   z=x+y;
   print z; 
   x=y;
   y=z;
  }
 } 
    }'


//var random = function(){}
var blackListxy= new Array(10);
var shipArray=new Array(5);
var shipcount=0;
var min0 = 0;
var max0 = 9;
var random2;
var size=new Array();
size[0]=2;
size[1]=3;
size[2]=3;
size[3]=4;
size[4]=5;
var oldi=0;
var i=0;
// and the formula is:
var j=0;
var loop;

function create2DArray(){
    for (var loop = 0; loop < 10; loop++) {
        blackListxy[loop] = new Array(10);
        for(var z=0;z<10;z++)
        blackListxy[loop][z]=0;
    }


    for (var loop = 0; loop < 5; loop++)
    shipArray[loop] = new Array(5);
}

window.getCoord = function getCoord(){
    create2DArray();

    while(i<=4)
    {
    randomize();
    }

//    var string1="[";
//    for(loop=0;loop<5;loop++){
//
//    string1 =string1+"{\"ship_id\":\""+shipArray[loop][0]+"\","+
//        "\"alignment\":\""+shipArray[loop][1]+"\","+
//        "\"size\":\""+shipArray[loop][2]+"\","+
//        "\"x_cord\":\""+shipArray[loop][3]+"\",";
//    if(loop<4)
//    string1=string1+"\"y_cord\":\""+shipArray[loop][4]+"\"},";
//            else
//            string1=string1+"\"y_cord\":\""+shipArray[loop][4]+"\"}";
//
//    }
//    string1=string1+"]";
//    alert(string1);

    return shipArray
}
function randomize()
{
// select the H or V for the first ship
                min1=0;  //horizontal
                max1=1; //vertical

                var random2= Math.floor(Math.random() * (max1 - min1 + 1)) + min1;


                if(random2)
                {      max1=9;min1=0;
                var x = Math.floor(Math.random() * (max1 - min1 + 1)) + min1;
                do
                {
                var y = Math.floor(Math.random() * (max1 - min1 + 1)) + min1;
                }while(y+size[i] > 9);


            for(loop=0;loop<size[i];loop++)
		 {
             if(blackListxy[x][y+loop]==1)
             {
             return;
             }
                }

                for(j=0;j<size[i];j++)
        {
            blackListxy[x][y+j]=1;
            }
                    /* fill the array */
                    shipArray[i][0]=i;
                    if(random2)
                    shipArray[i][1]='v';
		else
		shipArray[i][1]='h';
		shipArray[i][2]=size[i];
		shipArray[i][3]=x;
		shipArray[i][4]=y;
		i++;
		//alert("vertical"+random2);
		//alert("x coordinate"+x);alert("y coordinate"+y);
   }
   else
   {      max1=9;min1=0;
          var y = Math.floor(Math.random() * (max1 - min1 + 1)) + min1;
          do
          {
           var x = Math.floor(Math.random() * (max1 - min1 + 1)) + min1;
          }while(x+size[i] > 9);


          for(loop=0;loop<size[i];loop++)
		   {
		    if(blackListxy[x+loop][y]==1)
              {
					  return;
		      }
		   }


	    for(j=0;j<size[i];j++)
        {
		 blackListxy[x+j][y]=1;
		}

		/* fill the array */
		shipArray[i][0]=i;
		if(random2)
		shipArray[i][1]='v';
		else
		shipArray[i][1]='h';
		shipArray[i][2]=size[i];
		shipArray[i][3]=x;
		shipArray[i][4]=y;

		i++;
		//alert("vertical"+random2);
		//alert("x coordinate"+x);alert("y coordinate"+y);
   }

}

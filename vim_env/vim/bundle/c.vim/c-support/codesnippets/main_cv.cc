#include <cstdlib>
#include <fstream>
#include <iomanip>   
#include <iostream>   
#include <opencv/cv.h>
#include <opencv/highgui.h>
   

using namespace std;
using namespace cv;

// ===  FUNCTION  ======================================================================
//         Name:  main
//  Description:  main function
// =====================================================================================
int main ( int argc, char *argv[] )
{
	Mat image;  
	cout << "\nProgram " << argv[0] << endl << endl;

	if ( argc != 2 ) {
	    cout << "please input image name...\n" << endl;
	    return -1;
	}
	cout	<< "name: " << argv[1] << endl;
	image = imread(argv[1], 1);

	if (!image.data) {
	    printf("No image data\n");
	    return -1;
	}

	/*-----------------------------------------------------------------------------
	 *  create one window that called by test_cv
	 *-----------------------------------------------------------------------------*/
	namedWindow("test_cv", WINDOW_NORMAL);
	imshow("test_cv", image);
	waitKey(0);

	return EXIT_SUCCESS;
}		// ----------  end of function main  ---------- 



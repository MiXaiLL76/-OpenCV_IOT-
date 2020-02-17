#include <stdio.h>
#include "CMakeFiles/opencv_junk/version.junk"
#define CV_VERSION2 CVAUX_STR(CV_VERSION_MAJOR) "." CVAUX_STR(CV_VERSION_MINOR) "." CVAUX_STR(CV_VERSION_REVISION)
int main (void){printf(CV_VERSION2);}
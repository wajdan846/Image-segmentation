# Image-segmentation
Segmentation of CXR images that will separate lungs from background. These segmented images can be furthur used
for cases like classification(identification) of TB and healthy individuals.



# Two phase
Run the twophase.m file on MATLAB. This code is performing an image segmentation algorithm called the "two-phase level set method" on a given image. The algorithm is used to separate the objects in an image from the background.

First, it converts the image to double precision. Then, it initializes the level set function (which is used to separate the objects) with two circles. These circles are used as the initial contour to define the objects in the image.

The code then performs several iterations of an algorithm called "drlse_edge" to evolve the contour defined by the level set function, to better fit the objects in the image. This algorithm is partial differential equation solver.

Finally, the code produces the final segmented image, where any pixels inside the contour are set to 255 (white) and the others are unchanged.

The functions gd, drlse_edge, div, Dirac are the helper function for the main function. They are all used during the iterations performed by the "drlse_edge" algorithm to help improve the fit of the contour to the objects in the image.

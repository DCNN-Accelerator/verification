import matlab.engine
from scipy.signal import correlate2d
import numpy as np
import cv2

"""
This script loads an image and a kernel, preprocesses them, and then calls the MATLAB-based implementation
of our FPGA Convolution algorithm to perform image filtering. The results are validated using SciPy, and asserts
"True" when the convolution passes, and "False" when the convolution from MATLAB does not match the SciPy convolution.

For thorough testing, we will be loading in 1000 images from the CIFAR-10 image dataset 
"""
def preprocess(img,size):
    # Takes in an image and converts it to greyscale and the user dims
    return cv2.resize (cv2.cvtColor(img,cv2.COLOR_BGR2GRAY),(size,size),interpolation=cv2.INTER_AREA)
    
def generate_kernel(kernel_size):

    kernel = np.zeros([kernel_size,kernel_size])
    kernel[0:3,:] = -1
    kernel[4:7,:] =  1
    return kernel 

def generate_txt(img,kernel):

    np.savetxt('img.txt',img)
    np.savetxt('kernel.txt',kernel)

def extractValidFM(fmStream, paddedDims, num_pad_layers):
    arr = np.reshape(fmStream, paddedDims)
    return arr[num_pad_layers:-num_pad_layers, num_pad_layers:-num_pad_layers]
    

def checkMATLABOutput(img,kernel,fpgaFM,rtol):

    # Computes the ground truth correlation and checks the MATLAB output for similiarity based on a tolerance
    actualFM = correlate2d(img,kernel,'same')
    valid = np.allclose(actualFM, fpgaFM, rtol)

    if valid: 
        print("Test Passed!") 
    else: 
        print("Test Failed.")
    
    return valid 

def runMATLABSim(matlab, img_pth, kernel_size): 

    # Load image, preprocess and zero pad
    img = cv2.imread(img_pth)
    num_pad_layers = int(kernel_size/2)

    rescaled_img = preprocess(img,512)
    padded_img   = np.pad(rescaled_img, num_pad_layers, mode='constant')

    # Generate Edge detection kernel
    kernel = generate_kernel(kernel_size)

    # Save image and array to text files, not the cleanest solution but it works 
    generate_txt(padded_img,kernel)

    # Load image and kernel arrays into matlab
    img_matlab    = matlab.importdata('img.txt')
    kernel_matlab = matlab.importdata('kernel.txt')

    # Call FPGA_Runner.m from MATLAB to test the FPGA conv algorithm
    execTime, fmStream = matlab.FPGA_Runner(img_matlab,kernel_matlab,nargout=2)
    print("Execution Time: {} min".format(execTime/60))

    
    fmStream = np.asarray(fmStream)
    fpgaFM   = extractValidFM(fmStream, paddedDims=padded_img.shape, num_pad_layers=num_pad_layers)

    # Check the matlab output, and give pass/fail
    checkMATLABOutput(rescaled_img,kernel,fpgaFM, rtol=1e-5)

if __name__ == "__main__":

    eng = matlab.engine.start_matlab()
    eng.addpath('C:/Users/hkhaj/Desktop/Senior-Project/verification/emulation/util')

    runMATLABSim(eng, img_pth='baby_yoda.jpeg', kernel_size=7)




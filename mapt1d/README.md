# MAPT1D
Quantitative Pancreas MRI
Jack Virostko
January 13, 2021

The 'MAPT1D_20210113.m' Matlab code performs quantitative analysis of pancreatic MRI acquired using a standardized MRI protocol on Philips or Siemens scanners. Standardized pancreas MRI acquisition protocol for Philips scanners is provided in 'MAPT1D_Philips_20210113.ExamCard.'  Standardized pancreas MRI acquisition protocol for Siemens scanners is provided in 'MAPT1D_Siemens_20210113.exar1.'  Additional information on the Multicenter Assessment of the Pancreas in Type 1 Diabetes (MAP-T1D) project can be found here: https://www.map-t1d.com/

DICOM files are loaded using a GUI and then processed to yield measurements of pancreas volume, surface area to volume ratio, longitudinal relaxation time (T1), apparent diffusion coefficient (ADC), magnetization transfer ratio (MTR), fat fraction, and effective transverse relaxation rate (T2*). 

Code was written and tested using MATLAB_R2019A. 

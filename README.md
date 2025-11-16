# **Blood Vessel Segmentation in Retinal Images**

### **Project Description**
This project implements a classical multi-stage **Digital Image Processing (DIP)** pipeline to segment retinal blood vessels from High-Resolution Fundus (HRF) images. The method combines spatial enhancement, frequency filtering, low-rank denoising, and multiscale vesselness detection to extract both major and minor retinal vessels.

Developed as part of **UE23EC342AC1 – Digital Image Processing (PES University)**.

---

## **Summary**
The pipeline extracts retinal vessels through the following stages:
- Green channel extraction (highest vessel contrast)
- Local contrast enhancement using **CLAHE**
- Low‑rank noise removal using **SVD**
- Frequency‑domain refinement using **DCT**
- Image sharpening to enhance edges
- **Frangi / Hessian-based vesselness filtering**
- Adaptive thresholding
- Morphological refinement (closing, bridging, spur removal)
- Final binary mask + overlay visualization

This produces clean and continuous vessel maps suitable for ophthalmic screening.

---

## **Course Concepts Used**
1. **Image Enhancement – Spatial Domain**  
   CLAHE, sharpening, filtering
2. **Image Transforms**  
   DCT, SVD
3. **Morphological Image Processing**  
   Closing, bridging, spur removal
4. **Thresholding**  
   Adaptive/local thresholding
5. **Noise Reduction**  
   Low-rank SVD denoising

---

## **Additional Concepts Used**
1. **Frangi Vesselness Filtering** – Multiscale Hessian-based tubular structure detection.
2. **Overlay Visualization** – Shows segmented vessels over the original image.

---

## **Dataset**
### **HRF – High Resolution Fundus Dataset**
- 45 retinal fundus images
- 3504 × 2336 resolution
- Contains: Healthy, Diabetic Retinopathy, Glaucoma (15 each)
- Includes manually annotated ground-truth vessel masks

Used widely for benchmarking retinal vessel segmentation.

---

## **Novelty**
1. **Hybrid Multi-Domain Enhancement Pipeline** combining SVD → DCT → Frangi.
2. **SVD Before Vesselness Filtering** improves thin vessel detection.
3. **Sequential Enhancement Strategy** prepares cleaner inputs at every stage.

---

## **Contributors**
1. **Tushar G Bhat (PES1UG23EC333)**
2. **V K Sumedha (PES1UG23EC337)**
3. **Vismayee S P (PES1UG23EC355)**

---

## **Steps to Run**
### 1. Clone Repository
```bash
[git clone https://github.com/Digital-Image-Processing-PES-ECE/project-name.git](https://github.com/DIP-2025-MINI-PROJECT/Blood-Vessel-Segmentation-in-Retinal-Images)
```

### 2. Run MATLAB Code
Open the main MATLAB script and run directly.

Requires:
- MATLAB
- Image Processing Toolbox
- (Optional) Frangi filter implementation or Hessian-based alternative

---

## **Outputs**
The repository includes:
- Green channel images
- CLAHE-enhanced output
- SVD-denoised output
- DCT-enhanced output
- Vesselness filter response
- Final binary mask
- Red-channel vessel overlay

---

## **References**
1. Gonzalez & Woods – *Digital Image Processing*, 2018
2. Frangi et al., "Multiscale Vessel Enhancement Filtering," MICCAI, 1998
3. Hoover et al., *IEEE TMI*, 2000
4. Staal et al., *IEEE TMI*, 2004
5. Niemeijer et al., ROC Challenge, *IEEE TMI*, 2010

---

## **Limitations and Future Work**
- Difficulty capturing extremely thin capillaries
- Slight boundary noise in complex pathological cases

### Future Improvements:
- Incorporate U‑Net or Attention U‑Net
- Hybrid classical + deep-learning methods
- Quantitative evaluation across full HRF dataset
- Parameter optimization and speed improvements



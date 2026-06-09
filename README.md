# IE_survey

This repository provides supplementary codes and resources for our survey manuscript:

**“Image Encryption over Three Decades: A Survey of Foundations, Taxonomies, and Open Challenges”**

The survey paper is currently under peer review. This repository is maintained to support readers and researchers interested in image encryption by providing representative implementations, evaluation tools, and auxiliary resources related to several important branches of image encryption.

## Overview

Image encryption has evolved from handcrafted permutation–diffusion mechanisms to data-driven and quantum-inspired paradigms. Different technical routes, such as chaotic maps, S-boxes, compressive sensing, DNA encoding, hashing mechanisms, and statistical security evaluation, have been widely explored for protecting visual information in modern communication and multimedia systems.

This repository collects a set of supporting codes used to illustrate, analyze, and evaluate representative components discussed in our survey. The goal is to provide a practical reference for researchers who wish to understand common implementation procedures and empirical evaluation metrics in image encryption studies.

## Repository Contents

The repository currently includes the following modules:

* **Compressive sensing codes**: basic implementations related to compressive sensing-based image encryption.
* **DNA encoding toolbox**: auxiliary functions for DNA encoding and decoding operations commonly used in image encryption.
* **Encryption performance analysis**: tools for evaluating encrypted images using commonly adopted statistical metrics.
* **Hashing codes**: hash-related routines for key generation, plaintext sensitivity, and encryption control.
* **Metrics codes for chaotic systems**: codes for analyzing chaotic behavior and sequence complexity.
* **S-box metrics codes**: tools for evaluating cryptographic properties of S-boxes, including nonlinearity, differential behavior, and avalanche-related indicators.

## Purpose

This repository is intended to:

1. Support the reproducibility and transparency of the survey-related technical discussion.
2. Provide reusable tools for evaluating image encryption schemes.
3. Help researchers understand the implementation details of commonly used modules in image encryption.
4. Serve as a continuously updated resource accompanying the survey paper.

## Note

The current version is released as a supplementary resource for a manuscript under review. More codes, documentation, and examples will be gradually updated after further revision and publication of the survey paper.

## Citation

If you find this repository useful, please consider citing our survey paper once it becomes available.

```bibtex
@article{jiang2026image,
  title   = {Image Encryption over Three Decades: A Survey of Foundations, Taxonomies, and Open Challenges},
  author  = {Jiang, Donghua and Khan, Muhammad Shahbaz and Khan, Muhammad Khurram and Zhou, Nanrun and Wang, Mengmeng and Hu, Xianglei and Mumtaz, Shahid and Boulila, Wadii and Ahmad, Jawad},
  journal = {IEEE Communications Surveys & Tutorials},
  year    = {2026}
}
```

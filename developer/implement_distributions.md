---
category: implementation
index: 1
---

# Implementing a distribution
{:.section}

## General info before getting started
{:.subsection}

* Within the RevBayes **core** directory, there are subdirectories for different categories of distributions. 
All predefined mathematical distributions that have been implemented exist in `core/distributions/math`.

* Note that when implementing a new distribution, you will need to create `.cpp` and `.h` files in both the **revlanguage** directory and the **core** directory. (For a refresher on the difference between these two directories, refer to the 'Getting familiar with the code' section of this Developer's guide).
The overall naming format remains the same for every distribution in RevBayes. In the Beta Binomial Distribution example provided below, I specify what to name each file.

* It is often helpful to look at / 'borrow' code from existing RevBayes distributions for general help on syntax and organization.

For the language side, one of the most important things is the create distribution function (it converts user-arguments into calculations). Also, the getParameterRules function is important (to get the degrees of freedom & other things). It is often helpful to look at the code of existing distributions for general help on syntax & organization.

Within your new distribution, you will need to include some functions. For example, each new distribution must have: the get class type, name, and help. You may not need to implement these from scratch (if they're dictated by the parent class & are already present), but you will need to implement other functions within your distribution (e.g. cdf, rv, quantile). 

Distributions have a prefexed DN (dag node), and all moves have a previxed MV. RevBayes takes the name within & creates the DN automatically, so be aware of this. 


 
In the following steps, we'll implement the Beta Binomial Distribution as an example, for syntax purposes.

## Steps
{:.subsection}

1.  Create new .cpp & .h files in `revlanguage/distributions/math/` named `Dist_betabinomial.cpp` and `Dist_betaBinomial.h`. 
 *Note: all files in this directory will follow this naming format*

    To populate these files, look at existing examples of similar distributions for specific info on what to include & on proper syntax.  For example, for the Beta Binomial distribution, I looked to the existing Binomial Distribution code for guidance.
    
```cpp 
//add code here
```

2.  Test
    1.  Create new `.cpp` & `.h` files in `core/distributions/math/` named `BetaBinomialDistribution.cpp` and `BetaBinomialDistribution.h`.

        **Note:** This is the object oriented wrapper code, that references the functions hard-coded in the next step.
    
    2.  Create new .cpp and .h files in `core/math/Distributions/` named `DistributionBetaBinomial.cpp` and `DistributionBetaBinomial.h`. 

        These are the raw procedural functions in the RevBayes namespace (e.g. pdf, cdf, quantile); they are not derived functions. RbStatistics is a namespace. To populate these files, look at existing examples of similar distributions to get an idea of what functions to include, what variables are needed, and the proper syntax.

        **Note:** This is the most time-consuming step in the entire process of implementing a new distribution.


3.  Navigate to `revlanguage/workspace/RbRegister_Dist.cpp` 

    Every implementation you add must be registered in RevBayes. All register files are located in the `revlanguage/workspace` directory, and there are different files for the different implementations (`RbRegister_Func.cpp` is for new functions; `RbRegister_Move` is for new types; etc.).  We are implementing a distribution, so we will edit the `RbRegister_Dist.cpp file`.

4.  You need to have an include statement at the top of the RbRegister script, to effectively add your distribution to the RevBayes language. You also need to add code to the bottom of this file, and give it a type and a ‘new’ constructor. Generally, you can look within the file for an idea of proper syntax to use. 

    For the Beta Binomial distribution, we navigate to the section in the file with the header 'Distributions' and then look for the sub-header dealing with math distributions. Then, add the following line of code:

    ```cpp
    #include "Dist_betaBinomial.h"
    ```

    This step registers the header file for the beta binomial distribution, effectively adding it to RevBayes.

    Next, navigate to the section of the file that initializes the global workspace. This section defines the workspace class, which houses info on all distributions. Then, add the following line of code: 

    ```cpp
    AddDistribution< Natural		>( new Dist_betaBinomial());
    ```


    This adds the distribution to the workspace. Without this step, the betaBinomial will not be added to the revlanguage.
    
    **Note:** Depending on the type of distribution, you may need to change `Natural` to a different type (e.g. `Probability`, `Real`, `RealPos`, etc.).
    
5.  Before pushing your changes, you should ensure your code is working properly. 

    There are multiple ways to do this, so use your best judgment. As a best practice, you should first compile it to ensure there are no errors. Once it compiles, you can test it various ways (e.g. run your individual functions within the new Beta Binomial distribution in R, then run the Binomial distribution with a Beta prior in Rev and see if the output matches).  
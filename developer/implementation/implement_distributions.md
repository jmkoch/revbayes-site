---
title: Implementing a distribution
category: implementation
order: 1
---

## General info before getting started

* RevBayes is written in C++, so you will need to be somewhat familiar with C++ syntax when implementing in RevBayes.   

* Within the RevBayes **core** directory, there are subdirectories for different categories of distributions. 
All mathematical distributions that have been implemented exist in `core/distributions/math`.

* Note that when implementing a new distribution, you will need to create `.cpp` and `.h` files in both the **revlanguage** directory and the **core** directory. (For a refresher on the difference between these two directories, refer to the {% page_ref architecture %} section of this Developer's guide).
The overall naming format remains the same for every distribution in RevBayes. In the Beta Binomial Distribution example provided below, I specify what naming convention to use when creating each file.

* It is often helpful to look at/borrow code from existing RevBayes distributions for general help on syntax and organization.

For the language side, one of the most important things is the create distribution function (it converts user-arguments into calculations). Also, the getParameterRules function is important (to get the degrees of freedom & other things). It is often helpful to look at the code of existing distributions for general help on syntax & organization.

* Within every new distribution, you will need to include some functions. For example, each new distribution must have: the get class type, name, and help functions. You may not need to implement these from scratch (if they're dictated by the parent class & are already present), but you will need to implement other functions within your distribution (e.g. cdf, rv, quantile). 

* Distributions have a prefexed DN (dag node), and all moves have a previxed MV. RevBayes takes the name within & creates the DN automatically, so be aware of this. For a refresher on DAG nodes, refer [to this page]({% page_url architecture %}). 
 
In the following steps, we'll implement the **Beta Binomial Distribution** as an example, for syntax purposes.

## Steps

1.  Create new .cpp & .h files in `revlanguage/distributions/math/`, named `Dist_betabinomial.cpp` and `Dist_betaBinomial.h`. These files will contain the code that allows the Rev language to run the beta binomial distribution. 

     **Note:** all files in this directory will follow this naming format: 'Dist_(nameofdistribution).cpp/h'

    To populate these files, look at existing examples of similar distributions for specific info on what to include & on proper syntax.  For example, for the Beta Binomial distribution, I looked to the existing Binomial Distribution code for guidance. 
    
    The Dist_betabinomial.cpp file for this distribution will look like this:
    
```cpp 

```
   The Dist_betaBinomial.h file (that references the code written in Dist_betaBinomial.cpp) looks like this:
   
```cpp
#ifndef REVLANGUAGE_DISTRIBUTIONS_MATH_DIST_BETABINOMIAL_H_
#define REVLANGUAGE_DISTRIBUTIONS_MATH_DIST_BETABINOMIAL_H_

#endif /* REVLANGUAGE_DISTRIBUTIONS_MATH_DIST_BETABINOMIAL_H_ */

#ifndef Dist_betaBinomial_H
#define Dist_betaBinomial_H

#include "BetaBinomialDistribution.h"
#include "BetaDistribution.h"
#include "BetaBinomialDistribution.h"
#include "Natural.h"
#include "Probability.h"
#include "RlTypedDistribution.h"

namespace RevLanguage {

    /**
     * The RevLanguage wrapper of the beta-binomial distribution.
     *
     * The RevLanguage wrapper of the beta-binomial distribution simply
     * manages the interactions through the Rev with our core.
     * That is, the internal distribution object can be constructed and hooked up
     * in a model graph.
     * See the BetaBinomialDistribution for more details.
     *
     *
     * @copyright Copyright 2009-
     * @author The RevBayes Development Core Team (JK, WD, WP)
     * @since 2014-08-25, version 1.0
     *
     */
    class Dist_betaBinomial :  public TypedDistribution<Natural> {

    public:
                                                        Dist_betaBinomial(void);
        virtual                                        ~Dist_betaBinomial(void);

        // Basic utility functions
        Dist_betaBinomial*                                  clone(void) const;                                                                      //!< Clone the object
        static const std::string&                       getClassType(void);                                                                     //!< Get Rev type
        static const TypeSpec&                          getClassTypeSpec(void);                                                                 //!< Get class type spec
        std::string                                     getDistributionFunctionName(void) const;                                                //!< Get the Rev-name for this distribution.
        const TypeSpec&                                 getTypeSpec(void) const;                                                                //!< Get the type spec of the instance
        const MemberRules&                              getParameterRules(void) const;                                                          //!< Get member rules (const)
        void                                            printValue(std::ostream& o) const;                                                      //!< Print the general information on the function ('usage')

        // Distribution functions you have to override
        RevBayesCore::BetaBinomialDistribution*             createDistribution(void) const;

    protected:

        std::vector<std::string>                        getHelpAuthor(void) const;                                                              //!< Get the author(s) of this function
        std::vector<std::string>                        getHelpDescription(void) const;                                                         //!< Get the description for this function
        std::vector<std::string>                        getHelpDetails(void) const;                                                             //!< Get the more detailed description of the function
        std::string                                     getHelpExample(void) const;                                                             //!< Get an executable and instructive example
        std::vector<RevBayesCore::RbHelpReference>      getHelpReferences(void) const;                                                          //!< Get some references/citations for this function
        std::vector<std::string>                        getHelpSeeAlso(void) const;                                                             //!< Get suggested other functions
        std::string                                     getHelpTitle(void) const;                                                               //!< Get the title of this help entry

        void                                            setConstParameter(const std::string& name, const RevPtr<const RevVariable> &var);       //!< Set member variable

    private:

        RevPtr<const RevVariable>                       p;
        RevPtr<const RevVariable>                       n;
        RevPtr<const RevVariable>					   a;
        RevPtr<const RevVariable>					   b;
    };

}

#endif
```

 2. a. Create new `.cpp` & `.h` files in `core/distributions/math/`, named `BetaBinomialDistribution.cpp` and `BetaBinomialDistribution.h`.
This is the object oriented wrapper code, that references the functions hard-coded in the next step (step 2b). 

   **Note:** All files in this directory will follow this naming format: '(NameOfDistribution)Distribution.cpp/h'
   
   The BetaBinomialDistribution.cpp file will look like this:
   
```cpp
#include "BetaBinomialDistribution.h"
#include "DistributionBetaBinomial.h"
#include "RandomNumberFactory.h"
#include "RbConstants.h"
#include "RbException.h"

using namespace RevBayesCore;

BetaBinomialDistribution::BetaBinomialDistribution(const TypedDagNode<long> *m, const TypedDagNode<double> *alpha, const TypedDagNode<double> *beta) : TypedDistribution<long>( new long( 0 ) ),
    n( m ),
	a( alpha ),
	b( beta )
{

    // add the parameters to our set (in the base class)
    // in that way other class can easily access the set of our parameters
    // this will also ensure that the parameters are not getting deleted before we do
    addParameter( n );
    addParameter( a );
    addParameter( b );

    *value = RbStatistics::BetaBinomial::rv(n->getValue(), alpha->getValue(), beta->getValue(), *GLOBAL_RNG);
}


BetaBinomialDistribution::~BetaBinomialDistribution(void) {

    // We don't delete the parameters, because they might be used somewhere else too. The model needs to do that!
}


BetaBinomialDistribution* BetaBinomialDistribution::clone( void ) const {

    return new BetaBinomialDistribution( *this );
}


double BetaBinomialDistribution::computeLnProbability( void )
{

    // check that the value is inside the boundaries
    if ( *value > n->getValue() || *value < 0 )
    {
        return RbConstants::Double::neginf;
    }

    return RbStatistics::BetaBinomial::lnPdf(n->getValue(), a->getValue(), b->getValue(), *value);
}

void BetaBinomialDistribution::redrawValue( void ) {

    *value = RbStatistics::BetaBinomial::rv(n->getValue(), a->getValue(), b->getValue(), *GLOBAL_RNG);
}


/** Swap a parameter of the distribution */
void BetaBinomialDistribution::swapParameterInternal(const DagNode *oldP, const DagNode *newP)
{

    if (oldP == a)
    {
        a = static_cast<const TypedDagNode<double>* >( newP );
    }
    else if (oldP == b)
    {
        b = static_cast<const TypedDagNode<double>* >( newP );
    }
    else if (oldP == n)
    {
        n = static_cast<const TypedDagNode<long>* >( newP );
    }

}
```
  and the BetaBinomialDistribution.h file will look like:
  
```cpp
#ifndef CORE_DISTRIBUTIONS_MATH_BETABINOMIALDISTRIBUTION_H_
#define CORE_DISTRIBUTIONS_MATH_BETABINOMIALDISTRIBUTION_H_

#endif /* CORE_DISTRIBUTIONS_MATH_BETABINOMIALDISTRIBUTION_H_ */

#ifndef BetaBinomialDistribution_H
#define BetaBinomialDistribution_H

#include "TypedDagNode.h"
#include "TypedDistribution.h"

namespace RevBayesCore {

    /**
     * @brief Beta-Binomial distribution class.
     *
     * The Binomial distribution represents a family of distributions defined
     * on the natural number. The Beta-Binomial distribution has 2 parameters:
     *   n .. the number of trials
     *   p .. the probability of success
     * Instances of this class can be associated to stochastic variables.
     *
     * @copyright Copyright 2009-
     * @author The RevBayes Development Core Team (JK, WD, WP)
     * @since 2013-04-12, version 1.0
     *
     */
    class BetaBinomialDistribution : public TypedDistribution<long> {

    public:
        BetaBinomialDistribution(const TypedDagNode<long> *n, const TypedDagNode<double> *alpha, const TypedDagNode<double> *beta);
        virtual                                            ~BetaBinomialDistribution(void);                                             //!< Virtual destructor

        // public member functions
        BetaBinomialDistribution*                               clone(void) const;                                                      //!< Create an independent clone
        double                                              computeLnProbability(void);
        void                                                redrawValue(void);

    protected:
        // Parameter management functions
        void                                                swapParameterInternal(const DagNode *oldP, const DagNode *newP);        //!< Swap a parameter

    private:

        // members
        const TypedDagNode<long>*                            n;
        const TypedDagNode<double>*							a;
        const TypedDagNode<double>*							b;

    };

}

#endif
```

 2. b. Create new .cpp and .h files in `core/math/Distributions/`, named `DistributionBetaBinomial.cpp` and `DistributionBetaBinomial.h`. 

      These are the raw procedural functions in the RevBayes namespace (e.g. pdf, cdf, quantile); they are not derived functions. RbStatistics is a namespace. To populate these files, look at existing examples of similar distributions to get an idea of what functions to include, what variables are needed, and the proper syntax. Also, you will need to work out the math for your respective distribution, in order to properly define its procedural functions. 

      **Note:** This is the most time-consuming step in the entire process of implementing a new distribution. All files in this directory will follow this naming format: 'Distribution(NameOfDistribution).cpp/h'
      
      The DistributionBetaBinomial.cpp file will look like this:
      
```cpp
#include <cmath>
#include "DistributionBeta.h"
#include "DistributionBinomial.h"
#include "DistributionNormal.h"
#include "RbConstants.h"
#include "RbException.h"
#include "RbMathFunctions.h"
#include "RbMathCombinatorialFunctions.h"
#include "RbMathHelper.h"
#include "RbMathLogic.h"
#include "DistributionBetaBinomial.h"

using namespace RevBayesCore;

/*!
 * This function calculates the probability density 
 * for a beta-binomially-distributed random variable.
 * The beta-binomial distribution is the binomial distribution
 * in which the probability of successes at each trial is random,
 * and follows a beta distribution.
 *
 * \brief Beta Binomial probability density.
 * \param n is the number of trials. 
 * \param p is the success probability. 
 * \param x is the number of successes. 
 * \return Returns the probability density.
 * \throws Does not throw an error.
 */
double RbStatistics::BetaBinomial::cdf(double n, double a, double b, double x)
{
	throw RbException("The Beta Binomial cdf is not yet implemented in RB.");
}

/*!
 * This function draws a random variable
 * from a beta-binomial distribution.
 *
 * From R:
 *
 *     (1) pdf() has both p and q arguments, when one may be represented
 *         more accurately than the other (in particular, in df()).
 *     (2) pdf() does NOT check that inputs x and n are integers. This
 *         should be done in the calling function, where necessary.
 *         -- but is not the case at all when called e.g., from df() or dbeta() !
 *     (3) Also does not check for 0 <= p <= 1 and 0 <= q <= 1 or NaN's.
 *         Do this in the calling function.
 *
 *  REFERENCE
 *
 *	Kachitvichyanukul, V. and Schmeiser, B. W. (1988).
 *	Binomial random variate generation.
 *	Communications of the ACM 31, 216-222.
 *	(Algorithm BTPEC).
 *
 *
 * \brief Beta-Binomial probability density.
 * \param n is the number of trials.
 * \param pp is the success probability.
 * \param a is the number of successes. ????
 * \param b is the ????
 * \return Returns the probability density.
 * \throws Does not throw an error.
 */


int RbStatistics::BetaBinomial::rv(double n, double a, double b, RevBayesCore::RandomNumberGenerator &rng)
{
	int y;

	double p = RbStatistics::Beta::rv(a,b,rng);
	y = RbStatistics::Binomial::rv(n,p,rng);
	return y;
}

/*!
 * This function calculates the probability density 
 * for a beta-binomially-distributed random variable.
 *
 * \brief Beta-Binomial probability density.
 * \param n is the number of trials. 
 * \param p is the success probability. 
 * \param x is the number of successes. 
 * \return Returns the probability density.
 * \throws Does not throw an error.
 */
double RbStatistics::BetaBinomial::lnPdf(double n, double a, double b, double value) {

    return pdf(value, n, a, b, true);
}

/*!
 * This function calculates the probability density 
 * for a beta-binomially-distributed random variable.
 *
 * \brief Beta-Binomial probability density.
 * \param n is the number of trials. 
 * \param y is the number of successes.
 * \param a is the alpha parameter for the beta distribution
 * \param b is the beta parameter for the beta distribution
 * \return Returns the probability density.
 * \throws Does not throw an error.
 */


double RbStatistics::BetaBinomial::pdf(double y, double n, double a, double b, bool asLog)
{

    double constant;
    if (a==0)
    		return((y == 0) ? (asLog ? 0.0 : 1.0) : (asLog ? RbConstants::Double::neginf : 0.0) );
    		//return constant;

    if (b==0)
    		return((y == n) ? (asLog ? 0.0 : 1.0) : (asLog ? RbConstants::Double::neginf : 0.0) );
    		//return constant;

    constant = RevBayesCore::RbMath::lnChoose(n, y);


    	double prUnnorm = constant + RbStatistics::Beta::lnPdf(a, b, y);
    	double prNormed = prUnnorm - RbStatistics::Beta::lnPdf(a, b, y);

    	if(asLog == false)
    		return exp(prNormed);
    	else
    		return prNormed;
}


/*!
 * This function calculates the probability density 
 * for a beta-binomially-distributed random variable.
 *
 * From R:
 *
 *     (1) pdf() has both p and q arguments, when one may be represented
 *         more accurately than the other (in particular, in df()).
 *     (2) pdf() does NOT check that inputs x and n are integers. This
 *         should be done in the calling function, where necessary.
 *         -- but is not the case at all when called e.g., from df() or dbeta() !
 *     (3) Also does not check for 0 <= p <= 1 and 0 <= q <= 1 or NaN's.
 *         Do this in the calling function.
 *
 * \brief Beta Binomial probability density.
 * \param n is the number of trials. 
 * \param a is the alpha parameter.
 * \param b is the beta parameter.
 * \return Returns the probability density.
 * \throws Does not throw an error.
 */

//double RbStatistics::BetaBinomial::quantile(double quantile_prob, double n, double p)
double quantile(double quantile_prob, double n, double a, double b)
{
	throw RbException("There is no simple formula for this, and it is not yet implemented in RB.");
}
```
 The DistributionBetaBinomial.h file will look like this:
 
```cpp

#ifndef DistributionBetaBinomial_H
#define DistributionBetaBinomial_H

namespace RevBayesCore {

    class RandomNumberGenerator;

    namespace RbStatistics {
    
        namespace BetaBinomial {
        
            double                      pdf(double y, double n, double a, double b, bool log);     /*!< Beta Binomial probability density */
            double                      lnPdf(double n, double a, double b, double y);                       /*!< Beta Binomial log_e probability density */
            double                      cdf(double n, double a, double b, double x);                                    /*!< Beta Binomial cumulative probability */
            double                      quantile(double p, double n, double a, double b);                               		    /*!< Beta Binomial(n,p) quantile */
            int                         rv(double n, double a, double b, RandomNumberGenerator& rng);             /*!< Beta Binomial random variable */
	
            double                      do_search(double y, double *z, double a, double b, double n, double pr, double incr); // ?????
        }
    }
}

#endif
```

 3.  Navigate to `revlanguage/workspace/RbRegister_Dist.cpp` 

   **Every** new implementation must be registered in RevBayes in order to run. All register files are located in the `revlanguage/workspace` directory, and there are different files for the different types of implementations (`RbRegister_Func.cpp` is for registering functions; `RbRegister_Move` is for registering moves; etc.).  We are implementing a distribution, so we will edit the `RbRegister_Dist.cpp file`.

 You need to have an include statement at the top of the RbRegister script, to effectively add your distribution to the RevBayes language. You also need to add code to the bottom of this file, and give it a type and a ‘new’ constructor. Generally, you can look within the file for an idea of proper syntax to use. 

   For the Beta Binomial distribution, we navigate to the section in the file with the header 'Distributions' and then look for the sub-header dealing with 'math distributions'. Then, add the following line of code:


 ```cpp
 #include "Dist_betaBinomial.h"
 ```

   This step registers the header file for the beta binomial distribution, effectively adding it to RevBayes.

   Next, navigate to the section of the file that initializes the global workspace. This section defines the workspace class, which houses info on all distributions. Then, add the following line of code: 

 ```cpp
 AddDistribution< Natural		>( new Dist_betaBinomial());
 ```

   This adds the distribution to the workspace. Without this step, the beta binomial distribution will not be added to the revlanguage.
    
   **Note:** Depending on the kind of distribution, you may need to change `Natural` to a different type (e.g. `Probability`, `Real`, `RealPos`, etc.).
    
   After registering your distribution, you are ready to test your code.
    
 4. Before pushing your changes, you should ensure your code is working properly. 

    There are multiple ways to test your code, so use your best judgment. You should first compile your code to ensure there are no errors (e.g. if you're using the Eclipse IDE, select 'Project' and then 'Build Project'. Once it compiles with no errors/warnings, you can test it in various ways (e.g. run each individual function within the new Beta Binomial distribution in R, then run the Binomial distribution with a Beta prior in Rev and see if the output matches). 
    For more specific information on testing, see the (% page_ref testing/validation !! ADD THIS %) section of this Developer's Guide.
    
 5. After ensuring your code runs properly, you are ready to add it to the RevBayes git repo. You should fork your own copy of the repo, and contribute via a pull request. We also recommend reading through the {% page_ref git-flow %} section of the Developer's guide. Now, you are ready to push :octocat: !

---
title: Implementing a distribution
category: implementation
order: 1
---

## General info before getting started

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
#include "ArgumentRule.h"
#include "ArgumentRules.h"
#include "BetaBinomialDistribution.h"
#include "ContinuousStochasticNode.h"
#include "Dist_betaBinomial.h"  //don't forget to edit/populate the header file
#include "Probability.h"
#include "RealPos.h"
#include "RbException.h"
#include "DistributionBetaBinomial.h"
#include "RbHelpReference.h"

using namespace RevLanguage;

Dist_betaBinomial::Dist_betaBinomial(void) : TypedDistribution<Natural>()
{

}


Dist_betaBinomial::~Dist_betaBinomial(void)
{

}



Dist_betaBinomial* Dist_betaBinomial::clone( void ) const
{

    return new Dist_betaBinomial(*this);
}


RevBayesCore::BetaBinomialDistribution* Dist_betaBinomial::createDistribution( void ) const
{

    // get the parameters
    RevBayesCore::TypedDagNode<long>*    vn = static_cast<const Natural     &>( n->getRevObject() ).getDagNode();
    RevBayesCore::TypedDagNode<double>* vp = static_cast<const Probability &>( p->getRevObject() ).getDagNode();
    RevBayesCore::TypedDagNode<long>* va = static_cast<const Natural &>( a->getRevObject() ).getDagNode();
    RevBayesCore::TypedDagNode<long>* vb = static_cast<const Natural &>( b->getRevObject() ).getDagNode();
    RevBayesCore::BetaBinomialDistribution* d  = new RevBayesCore::BetaBinomialDistribution( vn, vp, va, vb );
    return d;
}



/* Get Rev type of object */
const std::string& Dist_betaBinomial::getClassType(void)
{

    static std::string rev_type = "Dist_betaBinomial";
	return rev_type;
}

/* Get class type spec describing type of object */
const TypeSpec& Dist_betaBinomial::getClassTypeSpec(void)
{

    static TypeSpec rev_type_spec = TypeSpec( getClassType(), new TypeSpec( Distribution::getClassTypeSpec() ) );
	return rev_type_spec;
}


/**
 * Get the Rev name for the distribution.
 * This name is used for the constructor and the distribution functions,
 * such as the density and random value function
 *
 * \return Rev name of constructor function.
 */
std::string Dist_betaBinomial::getDistributionFunctionName( void ) const
{
    // create a distribution name variable that is the same for all instance of this class
    std::string d_name = "betaBinomial";

    return d_name;
}


/**
 * Get the author(s) of this function so they can receive credit (and blame) for it.
 */
std::vector<std::string> Dist_betaBinomial::getHelpAuthor(void) const
{
    // create a vector of authors for this function
    std::vector<std::string> authors;
    authors.push_back( "Sebastian Hoehna" );

    return authors;
}


/**
 * Get the (brief) description for this function
 */
std::vector<std::string> Dist_betaBinomial::getHelpDescription(void) const
{
    // create a variable for the description of the function
    std::vector<std::string> descriptions;
    descriptions.push_back( "Beta Binomial probability distribution of x successes in n trials." );

    return descriptions;
}


/**
 * Get the more detailed description of the function
 */
std::vector<std::string> Dist_betaBinomial::getHelpDetails(void) const
{
    // create a variable for the description of the function
    std::vector<std::string> details;

    std::string details_1 = "";
    details_1 += "The binomial probability distribution defines the number of success in n trials,";
    details_1 += "where each trial has the same success probability p. The probability is given by";
    details_1 += "(n choose x) p^(x) * (1-p)^(n-p)";

    details.push_back( details_1 );

    return details;
}


/**
 * Get an executable and instructive example.
 * These example should help the users to show how this function works but
 * are also used to test if this function still works.
 */
std::string Dist_betaBinomial::getHelpExample(void) const 
{
    // create an example as a single string variable.
    std::string example = "";

    example += "p ~ dnBeta(1.0,1.0)\n";
    example += "x ~ dnBinomial(n=10,p)\n";
    example += "x.clamp(8)\n";
    example += "moves[1] = mvSlide(p, delta=0.1, weight=1.0)\n";
    example += "monitors[1] = screenmonitor(printgen=1000, separator = \"\t\", x)\n";
    example += "mymodel = model(p)\n";
    example += "mymcmc = mcmc(mymodel, monitors, moves)\n";
    example += "mymcmc.burnin(generations=20000,tuningInterval=100)\n";
    example += "mymcmc.run(generations=200000)\n";

    return example;
}


/**
 * Get some references/citations for this function
 *
 */
std::vector<RevBayesCore::RbHelpReference> Dist_betaBinomial::getHelpReferences(void) const
{
    // create an entry for each reference
    std::vector<RevBayesCore::RbHelpReference> references;


    return references;
}


/**
 * Get the names of similar and suggested other functions
 */
std::vector<std::string> Dist_betaBinomial::getHelpSeeAlso(void) const
{
    // create an entry for each suggested function
    std::vector<std::string> see_also;
    see_also.push_back( "dnBernoulli" );


    return see_also;
}


/**
 * Get the title of this help entry
 */
std::string Dist_betaBinomial::getHelpTitle(void) const
{
    // create a title variable
    std::string title = "Beta Binomial Distribution";

    return title;
}


/** Return member rules (no members) */
const MemberRules& Dist_betaBinomial::getParameterRules(void) const
{

    static MemberRules dist_member_rules;
    static bool rules_set = false;

    if ( !rules_set )
    {
        dist_member_rules.push_back( new ArgumentRule( "p", Probability::getClassTypeSpec(), "Probability of success.", ArgumentRule::BY_CONSTANT_REFERENCE, ArgumentRule::ANY ) );
        dist_member_rules.push_back( new ArgumentRule( "n", Natural::getClassTypeSpec()    , "Number of trials.", ArgumentRule::BY_CONSTANT_REFERENCE, ArgumentRule::ANY ) );
        rules_set = true;
    }

    return dist_member_rules;
}


const TypeSpec& Dist_betaBinomial::getTypeSpec( void ) const
{

    static TypeSpec ts = getClassTypeSpec();
    return ts;
}


/** Print value for user */
void Dist_betaBinomial::printValue(std::ostream& o) const
{

    o << "BetaBinomial(p=";
    if ( p != NULL )
    {
        o << p->getName();
    }
    else
    {
        o << "?";
    }
    o << ", n=";
    if ( n != NULL )
        o << n->getName();
    else
        o << "?";
    o << ")";
}


/** Set a member variable */
void Dist_betaBinomial::setConstParameter(const std::string& name, const RevPtr<const RevVariable> &var)
{

    if ( name == "p" )
    {
        p = var;
    }
    else if ( name == "n" )
    {
        n = var;
    }
    else
    {
        TypedDistribution<Natural>::setConstParameter(name, var);
    }
}

```

2. Create new `.cpp` & `.h` files in `core/distributions/math/`, named `BetaBinomialDistribution.cpp` and `BetaBinomialDistribution.h`.
This is the object oriented wrapper code, that references the functions hard-coded in the next step. 

   **Note:** All files in this directory will follow this naming format: '(NameOfDistribution)Distribution.cpp/h'
    
    2.  Create new .cpp and .h files in `core/math/Distributions/`, named `DistributionBetaBinomial.cpp` and `DistributionBetaBinomial.h`. 

        These are the raw procedural functions in the RevBayes namespace (e.g. pdf, cdf, quantile); they are not derived functions. RbStatistics is a namespace. To populate these files, look at existing examples of similar distributions to get an idea of what functions to include, what variables are needed, and the proper syntax.

        **Note:** This is the most time-consuming step in the entire process of implementing a new distribution. All files in this directory will follow this naming format: 'Distribution(NameOfDistribution).cpp/h'


3.  Navigate to `revlanguage/workspace/RbRegister_Dist.cpp` 

    **Every** new implementation must be registered in RevBayes in order to run. All register files are located in the `revlanguage/workspace` directory, and there are different files for the different types of implementations (`RbRegister_Func.cpp` is for registering functions; `RbRegister_Move` is for registering moves; etc.).  We are implementing a distribution, so we will edit the `RbRegister_Dist.cpp file`.

4.  You need to have an include statement at the top of the RbRegister script, to effectively add your distribution to the RevBayes language. You also need to add code to the bottom of this file, and give it a type and a ‘new’ constructor. Generally, you can look within the file for an idea of proper syntax to use. 

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
    
5.  Before pushing your changes, you should ensure your code is working properly. 

    There are multiple ways to do this, so use your best judgment. As a best practice, you should first compile it to ensure there are no errors. Once it compiles with no problems, you can test in various ways (e.g. run each individual function within the new Beta Binomial distribution in R, then run the Binomial distribution with a Beta prior in Rev and see if the output matches). For more information, see the section of this Developer's Guide entitled 'Testing/Validating'.
    
    After ensuring your code runs properly, you are ready to add it to the git repo. We recommend reading through the {% page_ref git-flow %} section of the Developer's guide before pushing. 

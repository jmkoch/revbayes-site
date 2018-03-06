---
layout: default
title: Tools for RevBayes Developers
---


## Joining the RevBayes Team

RevBayes is a collaborative software project involving developers from Europe and North America. 
Since RevBayes is open source, everyone is free to clone the [GitHub repository](https://github.com/revbayes/revbayes). 
If you would like to implement new methods or models in any of the RevBayes source code, you can contribute your work to the project by issuing a pull request on GitHub. 
Alternatively, if you are interested in joining the RevBayes development team, please contact [one of the public members](https://github.com/orgs/revbayes/people) to request access.

Before digging into the developer guide it may be useful to understand the user side of RevBayes. We have provided [tutorials]({{ site.baseurl }}/tutorials) that walk through the basics of using directed acyclic graphs (DAGs) for conducting phylogenetic analyses in RevBayes.   

## Developer Guide

The RevBayes Developers' Guide will provide you with the information needed to implement new methods, models, functions, and algorithms in the RevBayes language and core libraries. 


{% assign developer = site.pages | where:"layout", "developer" %}
{% assign devguide = developer | where:"category", "Developer" | sort: "index","last" %}
<table class="table table-striped">
{% for lesson in devguide %}
<tr>
<td class="col-sm-3">
<a href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title }}</a>
</td>
<td class="col-sm-3">{{ lesson.subtitle }}</td>
</tr>
{% endfor %}
</table>
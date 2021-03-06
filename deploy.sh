#!/bin/bash

# define a function to determine whether we are in a submodule
function is_submodule() 
{       
     (cd "$(git rev-parse --show-toplevel)/.." && 
      git rev-parse --is-inside-work-tree) 2>/dev/null | grep -q true
}

# make sure we are in the repo root
cwd=`pwd`
toplevel=`git rev-parse --show-toplevel`

if is_submodule || [ $cwd != $toplevel ]
then
    echo "Error: deploy.sh must be run from the repository root."
    exit 1
fi

# make sure we are on source branch
branch=`git rev-parse --abbrev-ref HEAD`

if [ "$branch" != "source" ]
then
    echo "Error: Cannot deploy from branch '$branch'. Switch to 'source' before deploying."
    exit 1
fi

# make sure there are no changes to commit
if git diff-index --quiet HEAD --
then
    msg=`git log -1 --pretty=%B`

    git pull origin source

    # build the site
    cd _site
    git fetch --quiet origin
    git reset --quiet --hard origin/master && git checkout --quiet master
    cd ..
    if ! bundle exec jekyll build; then
    	echo "Jekyll build failed. Master not updated."
    	exit 1
    fi
    cd _site

    untracked=`git ls-files --other --exclude-standard --directory`

    # check if there are any changes on master
    if git diff --exit-code > /dev/null && [ "$untracked" = "" ]
    then
        echo "Nothing to update on master."
        cd ..
    else
        # deploy the static site
        git add . && \
        git commit -am "$msg" && \
        git push --quiet origin master
        echo "Successfully built and pushed to master."
        cd ..

        # update submodule
        git add _site
        git commit --quiet --amend -m "$msg"
    fi
    
    # deploy source
    git push --quiet origin source
    echo "Deployment complete."
else
    echo "Error: Uncommitted source changes. Please commit or stash before updating master."
    exit 1
fi

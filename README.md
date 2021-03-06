revbayes.github.io
==========================

This is the repository for the RevBayes website.

Setting up this repo locally
=================

Clone the repository using the following command:

	git clone --recursive git@github.com:revbayes/revbayes-site.git

The static version of this site is stored as a submodule on branch `master` in the `_site` directory. The source files are stored on the default branch `source`.

In order to build the site you will need `jekyll`, see instructions below to install.

Making changes to the site
=================

When making changes to the site, you should always work on the `source` branch. After committing your changes to `source`, simply run the `deploy.sh` script. This script will take care of the steps involved to push both the `source` and `master` branches to github. 

	./deploy.sh

Setting up jekyll
=================

In order to build the site you will need to install [`jekyll`](https://jekyllrb.com/docs/installation/).

To install `jekyll` and `bundler` (or update them):

    gem install jekyll bundler

If you get a permission error, you can install the `jekyll` and `bundler` gems
in your home folder using:

    export GEM_HOME=~/.gem
    gem install jekyll bundler
    
NOTE: You may get errors here that you need to update ruby to install these
gems. 

Next, move into the `revbayes-site` repo directory, and install required gems via:

    bundle install

Now, you should be able to build and serve the static HTML with:

    bundle exec jekyll serve

The previous command will cause a full rebuild of the site each time a file is modified. This can sometimes take a long time. You can selectively regenerate only modified files using the `--incremental` option

	bundle exec jekyll serve --incremental

This will reduce regeneration times substantially. However, keep in mind that if you add new files, or modify `_config.yml` or any plugins, you will need to do a non-incremental rebuild.

If you get the error "invalid byte sequence in US-ASCII", this seems to fix it:

    export LC_CTYPE="en_US.UTF-8"
    export LANG="en_US.UTF-8"

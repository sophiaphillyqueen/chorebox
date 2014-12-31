# chorebox #

Configuration system for -chorekeeper- and related projects.

## Installation of main chorebox package ##

To install chorebox, the following litany should work:

    git clone http://github.com/sophiaphillyqueen/chorebox
    cd chorebox && ./local-configure && make install

The alternative form if you want to install in developer mode:

    git clone http://github.com/sophiaphillyqueen/chorebox
    cd chorebox && ./local-configure --devel_main && make install

If it's a system-wide installation you want, rather than just
on your individual account, the litany is as follows:

    git clone http://github.com/sophiaphillyqueen/chorebox
    cd chorebox && ./configure && make install

## Installation of chorebox-based packages ##

To install a package that depends on chorebox, take the
following litany, only replace <developer> with the developer's
account-name on github and <project> with the project name.

    git clone http://github.com/<developer>/</project>
    cd <project> && chorebox-in configure && make install

The alternative form if you want to install in developer mode:

    git clone http://github.com/<developer>/</project>
    cd <project> && chorebox-in configure --devel_main && make install

If it's a system-wide installation you want, rather than just
on your individual account, the litany is as follows:

    git clone http://github.com/<developer>/</project>
    cd <project> && sh configure && make install

## And what is this talk of "developer mode"? ##

What does developer mode mean? It means two things. For one
thing, it means that the build is done in a manner that is
less tolerant to coding mistakes - with the idea that this
intolerance gives the developer the opportunity to fix it
(as opposed to the non-developer, on whom such intolerances
will only be a source of extra frustration if the problem
isn't already fixed).

The other aspect of developer mode applies to cases where
the project uses a transpiler, and both the core-source and
the intermediate-source are present in the distribution.
In non-developer mode, the build will just use the intermediate
source-files and leave it at that --- while in developer mode,
the installation will build all the way from core source
(which will result in the intermediate sources being updated).

---
title: Data packages for current and future me
author: Thomas Van Hoey
date: '2019-12-09'
slug: data-packages
categories:
  - Blog
tags:
  - R
  - rstats
  - CHIDEOD
  - chinese
subtitle: ''
summary: ''
authors: []
lastmod: '2019-12-09T16:44:01+08:00'
featured: no
header:
  image: '2019/drakedatapackage.png'
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

# tl; dr

I show why it is worthwile to put my Chinese-related datasets in packages and how I went about it. 

# Introduction

I don't know if I'm very late to the party, but in this final sprint towards a finished dissertation, I keep finding myself juggling multiple datasets when using them in R.
This usually is paired with a `readr::read_csv()` or related functions, but the drawback is that I have to go find where I actually put that dataset on my computer.
This causes me some friction (even though the location didn't change), but what's worse is that that's actually not reproducible.
In other words, the code I wrote that way is **not portable**. 

# First trial: CHIDEOD

At some point during this year, I suddenly remembered some blog posts I had read like a year ago, on how to turn your dataset into an R package*.
My first experiment was the database I'm making myself, the **Chinese Ideophone Database** (CHIDEOD; available [here](https://osf.io/kpwgf/)). 
Somewhere in March/April this year I managed to turn that into a data package, and have done so with subesquent versions of CHIDEOD. 
It provided me with the functionality of just running a `library(CHIDEOD)` and BAM!, there was the `chideod` object to my disposal.

*More precisely the blog posts I read were:

* Ed Hagen's ["Put your data into an R package"](https://grasshoppermouse.github.io/2017/10/18/put-your-data-in-an-r-package/)
* Dave Kleinschmidt's ["Taking your data to go with R packages"](https://www.davekleinschmidt.com/r-packages/)
* Erick Howard's ["How to create an R data package"](https://www.erikhoward.net/how-to-create-an-r-data-package/)
* Hilary Parker's ["Writing an R package from scratch"](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/)

# Other datasets

Then somewhere in the beginning of this semester something clicked: I would take the other datasets I'm often working with, and find a way to turn them into data packages as well.
In concreto, those datasets are

* [Baxter and Sagart's Middle Chinese and Old Chinese reconstructions](http://ocbaxtersagart.lsait.lsa.umich.edu). This was all the more important, because this website has been unavailble at times *(maybe because there is no https certificate?, I don't know)*
* [Sun et al.'s Chinese Lexical Database](http://www.chineselexicaldatabase.com), a very good database for psycholinguistic information on simplified Chinese characters.
* The *Hànyǔ dà cídiǎn* 漢語大詞典, a giant monolingual dictionary of Chinese.
* The [Academia Sinica Balanced Corpus of Chinese ASBC 4.0](http://asbc.iis.sinica.edu.tw).

Now, I need to mention that for my own purposes, I have made some alterations to all of these datasets.

* For Baxter & Sagart's dataset, I've added things like an [IPA](https://en.wikipedia.org/wiki/International_Phonetic_Alphabet) version of the Middle Chinese (thanks to [sinopy](https://pypi.org/project/sinopy/)), a simplified column next to the traditional character one etc.
* For the Chinese Lexical Database, which is based on simplified characters, I found it useful to still add a traditional column and pull the characters of each word into traditional characters as well. Most of the psycholinguistic measures (entropy, reaction time etc.) are only valid for the simplified ones, but there is still a wealth of information that is useful for the traditional ones.
* I've [tidied up](https://r4ds.had.co.nz/tidy-data.html) the *Hànyǔ dà cídiǎn* 漢語大詞典, by splitting all the meanings that were numbered per lemma. 
* I was lucky to access an institutional version of the ASBC 4.0 but it was unfortunately coded in the programming-language-neutral XML, which is not fun to use (*"XML IS HELL"*). So I spent like a day turning it into nicely structured .Rds files. Not language-neutral (R-friendly) but easier to use for me. I also changed the spacing of the "Chines big space" (the one that is one square long and tall) to normal spacing; on top of the ugly tagging method of using brackets, e.g. 我(PRON), to less visually cluttered underscores, i.e. 我_PRON. 

![](/post/2019-12-09-data-packages_files/yodar.jpeg)

# Storing them somewhere

In an ideal scenario I would do this step first, but I actually did the package stuff (see next section) first. 
In this step I uploaded my datasets to a (private) repository.
Since my experience with the [Open Science Framework OSF](https://osf.io) had been positive, I decided to dump my datasets there.
This has the advantages that I can 1) version them, 2) access them from different devices (in case of computer crashes or changes etc.).
So now I need to find out how to shareable these new datasets are. 
I'm pretty sure I can't just make public the dictionary (even though I have transformed it), or the corpus -- although I think that these projects should be freely available.
The dataset by Baxter & Sagart and the Chinese Lexical Database should be a bit more available, but I will contact the authors shortly about these issues and when they are available, set the packages repositories on gitub to public, so you can all enjoy them.

# How to make a datapackage

The main tool I used to create these datapackages is the `DataPackageR` package. 
[This post on the ROpenSci blog](https://ropensci.org/blog/2018/09/18/datapackager/) explains pretty well the why and how, and I actually just used the "copy + adapt no [jutsu](https://naruto.fandom.com/wiki/Jutsu)" to make my packages.
It does warrant a basic know-how of R(studio) and github, so if you need to brush up on those skills, I can recommend Jenny Bryan's [Happy Git and GitHub for the useR](https://happygitwithr.com), a.k.a. *Happy git with R*. 

So that's what I did with most of the packages.
To see the one that is already public -- my CHIDEOD -- you can [go to this page](https://github.com/simazhi/chinese_ideophone_database).

And to download it, you should be able to do these functions

```
library(devtools)
install_github("simazhi/chinese_ideophone_database/CHIDEOD")
```

**If you find any problems with this functionality, please contact me!**


# Challenges

I don't know how to make the data package for the large-ish dataset of the *Hànyǔ dà cídiǎn* 漢語大詞典 (some 200 MB), since it is bigger than Github's size allowance. 
I just [found this blog on attaching larger datasets](https://thecoatlessprofessor.com/programming/r/r-data-packages-in-external-data-repositories-using-the-additional_repositories-field/), so I'm gonna check that out at some point.
Also the ASBC corpus, I have just stored in the repository, it's probably safer there.

Another challenge is naming the packages.
I've settled for:

* CHIDEOD
* CLD
* baxteRsagaRt
* (*future:* HYDCD)

# Conclusion

After updating to a new version of R (I read that R 4.0 is around the corner), and / or updating to a newer version of Rstudio, the dance of reinstalling previously installed packages will befall us once again.
But knowing that this includes (re)installing these datasets I made and that I often use, gives me some solace, because I (will?) have looked ahead to that moment and can just do a simple `install_github` and a `library(PACKAGE)` and *badabing badaboom*: I can run my scripts, in the now and in the future.

If the aforementioned parties are okay with it, I will make my github data packages public and share them in this post, so keep an eye out for that yo!






---
title: Guanguan goes the Chinese Word Segmentation (II)
author: Thomas Van Hoey
date: '2019-09-11'
slug: guanguan-goes-the-chinese-word-segmentation-2
categories:
  - Blog
tags:
  - R
  - python
  - coding
  - classics
  - CHIDEOD
subtitle: ''
summary: ''
authors: []
lastmod: '2019-09-11T12:27:22+08:00'
featured: no
header:
  image: '2019/guanguan1.jpg'
  caption: '[source](http://www.zonglanxinwen.com/img/7cacbaac7e7b7fec5a4d4c5bcb2c5dacdaebbaac.html)'
  focal_point: ''
  preview: yes
projects: []
---



# tl; dr

This double blog is first about the opening line of the *Book of Odes*, and later about how to deal with Chinese word segmentation, and my current implementation of it. So if you're only [interested in the computational part, look at the next one](../guanguan-goes-the-chinese-word-segmentation-2). If, on the other hand, you want to know more about my views on the translation of *guān guān* etc., [look at the first part](../guanguan-goes-the-chinese-word-segmentation).
In this part I use different approaches from a mostly R-centred focus to look at word segmentation in Chinese.

# Intro - quick recap

The issues that prompted me to write the previous post are twofold.
On the one hand, I came across a translation of the first line of the *Book of Odes* (*Shījīng* 詩經) and subsequent critiques of that translation. 
I decided to give my take on the extensive coverage of the first stanza.
Here is the first line as it is transmitted to us, as well with a translation I made.
(By the way, if you can provide a better translation, please bring it on.)


>關關雎鳩，  
在河之洲。  
窈窕淑女，  
君子好逑。   

> *Krōn, krōn* the físh-hawks cáll,  
ón the íslet ín the ríver.  
délicáte, demúre, young lády,  
fór the lórd a góód mate shé.

On the other hand, I have been reading up on how to deal with Chinese from a corpus linguistics point-of-view.
And that means also looking at how Natural Language Processing -- the next-door-neighbour of corpus linguistics -- deals with these issues.
To see why they are next-door-neighbours and not the same, you can read Gries's (2011) "Methodological and interdisciplinary stance in Corpus Linguistics".

Anyway, there are *a lot* of things you can do with corpora, also in Chinese, but in general there are a few steps you need to do before you can even begin analyzing linguistic data and throwing different models at the data.

# Steps involved in text analysis

[Welbers et al. (2017)](10.1080/19312458.2017.1387238) discuss the steps generally involved in text analysis, with a particular focus on [R](https://www.r-project.org).
These can be subsumed in three groups of tasks, and are exemplified with some R packages that may do the trick for that particular task.

![](/img/2019/Welbers2017.png)

**But**, what they forgot is that not every language comes with nicely defined space between the units (not necessarily words, because that concept is also a bit fuzzy). 
Chinese and Japanese are prime examples of this phenomenon.
A really quick google search led me to this [Quora post where they asked what the differences are between Chinese and English NLP (Natural Language Processing)](https://www.quora.com/What-are-the-main-differences-between-NLP-for-Chinese-vs-NLP-for-English), and the answers, provided a certain Chier Hu are pretty good ([check it out yo](https://qr.ae/TWKny4)). 

What I'm trying to get at here is that you need to break up long strings of Chinese first before you can even about putting things in the language modelling mixer.
So **below I am going to discuss a bit how I went about SEGMENTATION in the past, what some alternatives are, and what I'm doing now.**
**If you have any suggestions to improve this workflow, please contact me!**

# Alternatives

## The monosyllabic approach

What I'm looking for is actually not just a segmentation tool for Modern Chinese (which is difficult enough), but I want one that also works for Classical Chinese / Old Chinese.
The easiest option is to go with the idea that Classical Chinese is *mostly* monosyllabic (one syllable = one character = one word). 
If that is true, you can just go with the Julia Silge's brilliant `tidytext` package ([see free e-book here](https://www.tidytextmining.com)), and set your `token = "characters"`. 
That this is a possible venue is shown here by a certain jjon987, [who does an exploratory analysis of some classics in Chinese](http://jjohn987.rbind.io/post/a-quasi-tidytext-analysis-of-3-chinese-classics/).

I would give that an A for exploratory analysis, but a B for segmentation.
That is because what I'm looking for, is something that is able to also deal with polysyllabic words like ideophones, e.g. *guānguān* 關關 and *yáotiáo* 窈窕, or polysyllabic monomorphemes like *jūnzi* 君子, all present in this first stanza of the *Shījīng*.
So we need something a bit more sophisiticated.

## `stringi` based approaches

Both the [quanteda](https://quanteda.io/index.html) package and the [corpus](https://cran.r-project.org/web/packages/corpus/vignettes/corpus.html) package do make use of the `stringi` package to deal with the segmentation of Japanese and/or Chinese.
For an implementation of `quanteda` on Japanese, I really recommend looking at [Kohei Watanabe's post](https://koheiw.net/?p=339); for the instructions regarding `corpus`, [look here](https://cran.r-project.org/web/packages/corpus/vignettes/chinese.html).
Because I'm most familiar with the `quanteda` package and its functions, and because the underlying mechenism is the same, I'm only going to discuss this package below in "the test".

(I think `tidytext`'s `token = "words"` also uses `stringi` but I'm not sure.)

## oldies but goldies

The package most people are familiar with is probably `jieba` ([R version](https://qinwenfeng.com/jiebaR/) and [python version](https://github.com/fxsjy/jieba)).
This tends to work pretty well, but to be honest, it has always worked better for me in python, especially when I want to add custom dictionaries.
About those dictionaries, I don't know why, but often they are not enforced, and that is actually a dealbreaker for me.
Word on the street also has it that it works much better for Simplfied Chinese than for Traditional Chinese, but I haven't subjected this to tests myself.

## recent approaches

These last few years [numerous models have been introduced](http://nlpprogress.com/chinese/chinese_word_segmentation.html), each outperforming the previous one by one percent or so.
However, I wonder how much (corpus) linguists would agree with the standards from NLP -- there still seems to be a slightly more critical approach to the foundations of the issues.

That being said, most of these newer models include datasets that have benefited from neural networks etc. The [udpipe](https://bnosac.github.io/udpipe/docs/doc1.html) package brands itself as belonging to that category, and is thus worth exploring, especially since they have `classical_chinese-kyoto` dataset that can help you segment and tokenize your data. 
I'm curious if they can live up to the promises they make.


## python-integrated approaches

Last but not least is the group of R-and-python interfacing packages, all made possible (to me at least) through the [reticulate package](https://rstudio.github.io/reticulate/). 
With this I can basically run python from inside one of my R (markdown) scripts, and thus get the best of both worlds.
It's a bit of a hassle to set up at first, but if you manage to do it, the rewars are pretty sweet.

As for ~~packages~~ libraries (python lingo), the [jieba library](https://github.com/fxsjy/jieba) works pretty well.
But last week the CKIP team at Academia Sinica came out with this new tagging system, creatively called [ckiptagger](https://github.com/ckiplab/ckiptagger). 
At first sight, this one does seem to be able to enforce a dictionary, so maybe this is the one I want to be using.
Let's take these for a spin.

# Setting up the workspace and test materials

So in this part I want to showcase a bit how different packages treat the question of segmentation.

## Loading in the required libraries







































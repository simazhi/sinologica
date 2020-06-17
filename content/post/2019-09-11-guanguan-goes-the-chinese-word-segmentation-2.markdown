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

```r
library(tidyverse) #general catch-all of the tidyverse
library(quanteda)
library(tidytext)
library(jiebaR)
library(udpipe)

# python setup
library(reticulate)
use_python("/usr/local/bin/python3", required = T)
reticulate::py_config()
```

```
## python:         /usr/local/bin/python3
## libpython:      /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/config-3.7m-darwin/libpython3.7.dylib
## pythonhome:     /Library/Frameworks/Python.framework/Versions/3.7:/Library/Frameworks/Python.framework/Versions/3.7
## version:        3.7.5 (v3.7.5:5c02a39a0b, Oct 14 2019, 18:49:57)  [Clang 6.0 (clang-600.0.57)]
## numpy:          /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/numpy
## numpy_version:  1.17.1
## 
## NOTE: Python version was forced by use_python function
```

## Test material

As test material I just care about this stanza from the *Shījīng*.


```r
test <- c("關關雎鳩、在河之洲。",
          "窈窕淑女、君子好逑。")
```

Expected output:

```
關關 雎鳩 、 在 河 之 洲 。
窈窕 淑女 、 君子 好 逑 。
```

## `tidytext`


```r
test %>%
  tibble(.name_repair = ~ "lines") %>%
  unnest_tokens(word, lines, token = "words")
```

```
## # A tibble: 9 x 1
##   word    
##   <chr>   
## 1 關關    
## 2 雎鳩    
## 3 在      
## 4 河      
## 5 之      
## 6 洲      
## 7 窈窕淑女
## 8 君子    
## 9 好逑
```


```r
test %>%
  tibble(.name_repair = ~ "lines") %>%
  unnest_tokens(word, lines, token = "characters")
```

```
## # A tibble: 16 x 1
##    word 
##    <chr>
##  1 關   
##  2 關   
##  3 雎   
##  4 鳩   
##  5 在   
##  6 河   
##  7 之   
##  8 洲   
##  9 窈   
## 10 窕   
## 11 淑   
## 12 女   
## 13 君   
## 14 子   
## 15 好   
## 16 逑
```

Changing the argument `token` from `"words"` to `"characters"` shows that neither is the ideal output. 
The first one does capture most of the disyllabic words (=good) but the problem really lies with the phrase 窈窕淑女, which is treated as one block in the first and as four pieces in the second.
Technically you can do more collocationwise with the second, but that's not what I'm after here.

## `quanteda`


```r
quanteda.corpus <- corpus(test)
tokens(quanteda.corpus)
```

```
## Tokens consisting of 2 documents.
## text1 :
## [1] "關關" "雎鳩" "、"   "在"   "河"   "之"   "洲"   "。"  
## 
## text2 :
## [1] "窈窕淑女" "、"       "君子"     "好逑"     "。"
```

This gives the same problem: 窈窕淑女 is one block.
But maybe with a dictionary this problem can be solved?


```r
quant.dict <- dictionary(list(ideo = c("關關", "窈窕")))
quanteda.toks <- tokens(quanteda.corpus)
tokens_lookup(quanteda.toks, dictionary = quant.dict, levels = 1)
```

```
## Tokens consisting of 2 documents.
## text1 :
## [1] "ideo"
## 
## text2 :
## character(0)
```

```r
dfm(quanteda.corpus, dictionary = quant.dict)
```

```
## Document-feature matrix of: 2 documents, 1 feature (50.0% sparse).
##        features
## docs    ideo
##   text1    1
##   text2    0
```

This isn't really working -- the dictionary object in `quanteda` is mostly something for further text analysis (after segmentation).
I do seem to remember there is a function that ([`tokens_compound`](https://koheiw.net/?p=481)) that allows you to paste erroneously split words back together, but I don't know if you can customize the cutting?

## `jiebaR`


```r
cutter = worker()
segment(test, cutter)
```

```
## [1] "關關雎"   "鳩"       "在"       "河之洲"   "窈窕淑女" "君子好逑"
```

I wish I knew how to get the dictionary working, because then I would be able to just stay in R.
If anybody knows the fucntions, please tell me.
I would want something like this:

```
jiebaR.dict <- c("關關 5 id", "窈窕 5 id")
cutter2 <- worker(dict = jiebaR.dict)
segment(test, cutter2)
```

## `udpipe`


```r
#udmodel <- udpipe_download_model(language = "classical_chinese-kyoto")
udmodel_KC <- udpipe_load_model(file = "classical_chinese-kyoto-ud-2.4-190531.udpipe")
```


```r
x <- udpipe_annotate(udmodel_KC, x = test)
x <- as.data.frame(x)

tibble(x$token, x$upos)
```

```
## # A tibble: 18 x 2
##    `x$token` `x$upos`
##    <chr>     <chr>   
##  1 關        NOUN    
##  2 關雎      NOUN    
##  3 鳩        VERB    
##  4 、        PUNCT   
##  5 在        VERB    
##  6 河        NOUN    
##  7 之        SCONJ   
##  8 洲        VERB    
##  9 。        PUNCT   
## 10 窈        VERB    
## 11 窕        VERB    
## 12 淑        VERB    
## 13 女        PRON    
## 14 、        PUNCT   
## 15 君子      NOUN    
## 16 好        VERB    
## 17 逑        VERB    
## 18 。        PUNCT
```

Wow this is really weird.
It splits 關關雎鳩 as `關 關雎 鳩` instead of `關關 雎鳩`, and 窈窕淑女 as `窈 窕 淑 女` instead of the desired `窈窕 淑女`. 
I don't think I know how to improve this currently, as there are some dictionary settings that allow you to *suggest* but not necessarily *enforce* it.
Once again, if you know how, tell me now.

## `jieba` in python


```python
import jieba
```


```python
seg_list = jieba.cut("關關雎鳩、在河之洲。", cut_all=False)
print("Default Mode: " + "/ ".join(seg_list))  # 默认模式
```

```
## Default Mode: 關關/ 雎/ 鳩/ 、/ 在/ 河之洲/ 。
## 
## Building prefix dict from the default dictionary ...
## Loading model from cache /var/folders/kn/bjb0w7nx061145pnsxtwzpgc0000gn/T/jieba.cache
## Loading model cost 1.169 seconds.
## Prefix dict has been built succesfully.
```

```python
seg_list = jieba.cut("窈窕淑女、君子好逑。", cut_all=False)
#print("Default Mode: " + "/ ".join(seg_list))  # 默认模式
```

This doesn't give the desired results.


```r
a <-  c("關關 5", "窈窕 500", "雎鳩")
a
```

```
## [1] "關關 5"   "窈窕 500" "雎鳩"
```



```python
print(r.a)
```

```
## ['關關 5', '窈窕 500', '雎鳩']
```

```python
jieba.load_userdict(r.a)
#add_word('雎鳩', freq=None, tag=None)

seg_list = jieba.cut("關關雎鳩、在河之洲。", cut_all=False)
print("Default Mode: " + "/ ".join(seg_list))  # 默认模式
```

```
## Default Mode: 關關/ 雎鳩/ 、/ 在/ 河之洲/ 。
```

```python
seg_list = jieba.cut("窈窕淑女、君子好逑。", cut_all=False)
print("Default Mode: " + "/ ".join(seg_list))  # 默认模式
```

```
## Default Mode: 窈窕淑女/ 、/ 君子好逑/ 。
```

As you can see, it is really easy to just define a dictionary in R, because it is just a list (instead of feeding it a .txt file).
But I still don't know how to enforce it.
Do I just change the weight, and if so to what setting?

## `ckiptagger` (in python)

Last on the list is the recent `ckiptagger` library.
According to the [github page](https://github.com/ckiplab/ckiptagger) this model outperforms `jieba`:

Tool |	(WS) prec	| (WS) rec	| (WS) f1	| (POS) acc
-----|------------|-----------|---------|-----------
CkipTagger |	97.49% |	97.17% |	97.33% |	94.59%
CKIPWS (classic) |	95.85% |	95.96% |	95.91%	 |90.62%
Jieba-zh_TW	| 90.51% |	89.10%	| 89.80%	| --

I recommend following the steps for installation outlined over there because their tagged set is quite large (1.8 GB I or so), so you want that downloaded directly to your harddrive or a virtual environment or whatever it is the young kids do these days.



```python
from ckiptagger import *
#data_utils.download_data_gdown("./") # gdrive-ckip
#ws = WS("./data")
```

```
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorflow/python/framework/dtypes.py:516: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_qint8 = np.dtype([("qint8", np.int8, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorflow/python/framework/dtypes.py:517: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_quint8 = np.dtype([("quint8", np.uint8, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorflow/python/framework/dtypes.py:518: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_qint16 = np.dtype([("qint16", np.int16, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorflow/python/framework/dtypes.py:519: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_quint16 = np.dtype([("quint16", np.uint16, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorflow/python/framework/dtypes.py:520: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_qint32 = np.dtype([("qint32", np.int32, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorflow/python/framework/dtypes.py:525: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   np_resource = np.dtype([("resource", np.ubyte, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:541: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_qint8 = np.dtype([("qint8", np.int8, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:542: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_quint8 = np.dtype([("quint8", np.uint8, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:543: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_qint16 = np.dtype([("qint16", np.int16, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:544: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_quint16 = np.dtype([("quint16", np.uint16, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:545: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   _np_qint32 = np.dtype([("qint32", np.int32, 1)])
## /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:550: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
##   np_resource = np.dtype([("resource", np.ubyte, 1)])
```

```python
ws = WS("/Users/Thomas/data")
```


```python
word_list = ws(
    r.test 
    )
    
word_list
```

```
## [['關關', '雎鳩', '、', '在', '河', '之', '洲', '。'], ['窈窕淑女', '、', '君子', '好逑', '。']]
```

This is not ideal, but lets make a dictionary here too and run it.


```r
ideos <- c("關關", "窈窕")
vals <- c(rep(5, times = 2))

lijst <- as.list(vals)
names(lijst) <- ideos

lijst
```

```
## $關關
## [1] 5
## 
## $窈窕
## [1] 5
```
This is the format you want, because it matches the python format of 'dictionaries' the best.


```python
dictionario = construct_dictionary(r.lijst)
print(dictionario)
```

```
## [(2, {'關關': 5.0, '窈窕': 5.0})]
```



```python
word_list = ws(
    r.test,
    coerce_dictionary = dictionario
    )
    
word_list
```

```
## [['關關', '雎鳩', '、', '在', '河', '之', '洲', '。'], ['窈窕', '淑女', '、', '君子', '好逑', '。']]
```

By using the `coerce_dictionary` argument, you *force* this dictionary, to be used. 
So theoretically it should look at that first before it throws other segmentation stuff at the data.


```r
py$word_list %>%
  #unlist()%>%
  enframe() %>%
  unnest(value) %>%
  group_by(name) %>%
  summarise(sentence = str_c(value, collapse = " "))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 2 x 2
##    name sentence                   
##   <int> <chr>                      
## 1     1 關關 雎鳩 、 在 河 之 洲 。
## 2     2 窈窕 淑女 、 君子 好逑 。
```

Et voilà, segmented Classical Chinese, the way I want it.
(Well, I guess I would want 好逑 to be split in 好 and 逑 as well, but for now it's okay.)

The steps in this section thus consist of:
1. Providing target text (character vectors in R)
2. Making the dictionary (list in R)
3. Transforming the R dictionary to python dictionary (dictionary in python)
4. Running python script (import ckiptagger, load the ws data, run ws function with dictionary coerced)
5. Transform python object to nice dataframe in R (dataframe in R)

I can readily see applications with a dictionary list taken from the [Chinese Ideophone Database CHIDEOD](https://osf.io/kpwgf/), and maybe with other databases connected to it as well.

But I'm always open to hearing more ways of dealing with this preprocessing problem.

# Conclusions

Above I've showcased a number of packages and ways to deal with the problem of Chinese Word Segmentation.
Here's the score I would give them.

package / library | coding language | score | comment
------------------|-----------------|-------|-------
`tidytext` | R | 8 | if you want a quick solution ("characters") or okayish solution ("words")
`quanteda` | R | 8 | okayish solution, can't split smaller?
`jiebaR` | R | 7 | how to use the dictionary function?
`udpipe` | R | 6 | not developed enough / unclear instructions
`jieba` | python | 9 | with dictionaries you can get there, maybe; but how to enforce them?
`ckiptagger` | R + python | 9.5 | this method seems to get the ideophone job done, dictionaries can be enforced, but might also not be perfect?

**I hope you found this blog useful, but should you have tips on how to improve the workflow, always welcome.**
And thanks for sticking around until here.
As we say in Taiwan: 謝謝拜拜。

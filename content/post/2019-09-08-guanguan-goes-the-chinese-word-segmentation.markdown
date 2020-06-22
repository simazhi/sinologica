---
title: Guanguan goes the Chinese Word Segmentation (I)
author: Thomas Van Hoey
date: '2019-09-08'
slug: guanguan-goes-the-chinese-word-segmentation
categories:
  - Blog
tags:
  - coding
  - R
  - python
  - classics
header:
  caption: '[source](http://www.zonglanxinwen.com/img/7cacbaac7e7b7fec5a4d4c5bcb2c5dacdaebbaac.html)'
  image: '2019/guanguan1.jpg'
  preview: yes
---

# tl; dr

This double blog is first about the opening line of the *Book of Odes*, and later about how to deal with Chinese word segmentation, and my current implementation of it. So if you're only [interested in the computational part, look at the next one](../guanguan-goes-the-chinese-word-segmentation-2). If, on the other hand, you want to know more about my views on the translation of *guān guān* etc., [look at the first part](../guanguan-goes-the-chinese-word-segmentation).

# Intro

The other day I was browsing through some academic journals, and I came across this article by [Geoffrey Sampson](https://en.wikipedia.org/wiki/Geoffrey_Sampson), who I know mostly from (convincingly) attacking the Language Instinct hypothesis in linguistics.
That led me to his website ( [see here for the Language Instinct thing](https://www.grsampson.net/REmpNat.html) ), where I then found out has written a book that translates 58 poems from the [Shījīng](https://en.wikipedia.org/wiki/Classic_of_Poetry) 詩經, the *Book of Odes* or *Book of Songs* as it's most commonly known in English.
Sampson uses Baxter's (1992) reconstruction of Old Chinese on the left-hand side and translates poems on the right-hand side, [see here](https://www.grsampson.net/BLoveSEC.html).
This book was also reviewed by the [Edward Shaughnessy](https://en.wikipedia.org/wiki/Edward_L._Shaughnessy), an expert on very old Chinese (Shaughnessy, Edward. 2008. *Modern Philology* (106). 197-2000), where he argued that it's a nice translation, but then critiques some of the choices made.

# The issue

And this is where I address the topic of this blog post. The criticism is about the very first stanza of the very first ode of the *Shījīng*, called *Guān jū* 關雎. 
I'll first give this poem in full, with a translation by [James Legge](https://en.wikipedia.org/wiki/James_Legge) (dating from 1871), based on the [ctext](https://ctext.org/book-of-poetry/guan-ju) and the book (*The She King*) iself. 

> 關關雎鳩、在河之洲。  
窈窕淑女、君子好逑。  

> *Kwan-kwan* go the ospreys,  
On the islet in the river.  
The modest, retiring, virtuous, young lady: —  
For our prince a good mate she.  

>參差荇菜、左右流之。  
窈窕淑女、寤寐求之。  
求之不得、寤寐思服。  
悠哉悠哉、輾轉反側。  

>Here long, there short, is the duckweed,  
To the left, to the right, borne about by the current.  
The modest, retiring, virtuous, young lady: —  
Waking and sleeping, he sought her.  
>He sought her and found her not,  
And waking and sleeping he thought about her.  
Long he thought; oh! long and anxiously;  
On his side, on his back, he turned, and back again.  

>參差荇菜、左右采之。  
窈窕淑女、琴瑟友之。  
參差荇菜、左右芼之。  
窈窕淑女、鍾鼓樂之。  

>Here long, there short, is the duckweed;  
On the left, on the right, we gather it.  
The modest, retiring, virtuous, young lady: —  
With lutes, small and large, let us give her friendly welcome.  
> Here long, there short, is the duckweed;  
On the left, on the right, we cook and present it.  
The modest, retiring, virtuous, young lady: —  
With bells and drums let us show our delight in her.  

So as I said, Sampson's (2006) version gives the first line as follows:

> Krón, krón, tsa-kou  
Dzúh gáy tu tou  
Íwh-líwh diwk nrah  
Koun-tzuh hóuh grou.  

>Krón, krón calls the fish-hawk
on an islet in the river.  
A girl who is lovely and good  
Is the fit match for a princely man.  

Let's first see how this compares to the other translations Shaughnessy discusses, for example [Arthur Waley ](https://en.wikipedia.org/wiki/Arthur_Waley) (1937 / 1987:81):

> 'Fair, fair,' cry the ospreys  
On the island in the river.  
Lovely is this noble lady,  
Fit bride for our lord.  

Or [Bernhard Karlgren](https://en.wikipedia.org/wiki/Bernhard_Karlgren) (1950:2):

> *Kwan-kwan* (cries) the ts'ü-kiu bird, on the islet of the river;  
the beautiful and good girl, she is a good mate for the lord.

As for the quality of translation, I agree with Shaughnessy that Sampson's is not necessarily better than Legge, Waley or Karlgren.
My personal preference in this case still goes to the one by Legge (1871!).

# The first ideophone

But what is the most interesting, of course, is the SOUND ideophone (onomatopoeia) all the way in the beginning of the poem.
There seem to be a few choices possible: 1. either you keep the sound of the current Mandarin reading, i.e. *guānguān* / *kwan-kwan*; 2. or you translate with a possible English equivalent, i.e. *fair fair*; 3. or you use the reconstructed pronunciation, to evoque what it might have sounded like (phonologically) in ancient times, i.e. *kron kron*. 

So Shaughnessy at first seems to somewhat applaud the usage of *kron kron*:

> In principle, I believe that being able to "hear" the original is important to an appreciation of poetry, and so I think that the addition of these phonetic reconstructions is to be welcomed (although I am not at all sure that for readers who do not know Chinese "*Krón, krón, tsa-kou*" Sampson’s reconstruction, is much to be preferred over "*Guan guan ju jiu*" the standard Romanization of the modern Chinese pronunciation). 

But later on he critiques this first line as well:

> "*Krón, krón*" is supposed to be onomatopoeia for the sound that the fish-hawk makes as he calls to his mate. But here as elsewhere in the *Shi jing*, when animals, and especially birds, cry out, they do so in Chinese. In any event, their cries are necessarily rendered in Chinese characters, and the characters were obviously chosen not only for their sound but also for their meaning.

This is followed by Shaughnessy inspecting Sampson's glossary, where a singular *krón* is glossed as a crossbeam in a gate, and then extended to include meanings as diverse as 'pass (through mountains)', 'close', 'join, be related'.
And onomasiologically its form is similar to another word *guan*, reconstructed as *kons* 'to pass through', but extended to 'penetrate' (yes in the sexual way).
So Shaughnessy argues that there is some penetrating punning going on:

>  It seems to me that the fish-hawk is literally seeking "join" with his mate, and any translation that does not reflect that sense leaves the reader at an immediate loss.

While the rest of the review makes some good comments about the themes of lust (no caution) in the *Shījīng*, this rubbed me a little in the wrong way.
But let's now turn to Sampson's [reply](https://www.grsampson.net/CShau.html).

The biggest point Sampson makes is that Chinese studies should do more popularizing their findings, and that can be said of many disciplines. 
Books like his *Love songs in Early China* do contribute to that goal.

Then, about the first stanza where Shaughnessy critized Sampson's *krón (krón)* as involving a double entendre, Sampson dryly remarks: "Perhaps". 
And this is an apt response. 

It baffles me as well how you can relate onomatopoeia / SOUND ideophones, yes composed of characters, to just a reduplication of a homophone in this case.
As if translating 關關 with 'beam-beam', or 'join-join' (Sampson), or 'pass-pass' makes sense.
Shaughnessy's point makes as much sense as in the hypothetical situation where we would have *boe, daar is de koe* "moo, there is the cow" in Dutch with an English translation.
But *boe* not only is the sound of a cow in Dutch, it is also what you use to scare someone, cf. English *boo*. 
So should that extension into the semantic domain of FEAR be brought into the translation?
Perhaps.
Or, second similar example: *tok tok tok — vier kippen op een rij* "cluck cluck (cluck) — four chickens arranged in a row". 
Should we be translating *tok tok tok* as 'cluck', or knowing full well that the sequence *tok tok tok* is also used for 'knocking sound (on a door)', as "knock-knock go the four chickens"?
Perhaps not.

These silly examples are just thrown in here to show that, as Sampson argues, it is "irrelevant" to go looking up his *krón* when dealing with *krón krón*.
The second retort is about the formally similar *kons*.
Shaughnessy doesn't give any characters (or tones) in his review, but this is what Sampson finds:

> Having argued that 關, *krón*, should be read partly for its sense, Shaughnessy then claims to discern yet another layer of meaning: he says that this word is “similar in pronunciation” to 貫, whose primary meaning is "to pass through" but which has "the extended sense of sexual penetration". So perhaps the translation should be not " 'Join, join' …" but rather " 'Screw, screw' calls the fish-hawk".

> I find it surprising that the words 關 and 貫 were similar enough to be confusable in the Old Chinese period. (They are pronounced similarly in modern Mandarin – kuan1 [*guān*] versus kuan4 [*guàn*], a difference of tone only; but 貫 is normally taken to have ended in -*s* in Old Chinese: Shaughnessy gives it the pronunciation *kons*, and I would write *kóns*.) **However, in private correspondence Shaughnessy has shown me good evidence that the words were treated as to some extent interchangeable. Nevertheless, I remain sceptical about whether the meaning, rather than the pronunciation, of either word was relevant to hearers' appreciation of the poem. Rendering a crowing sound into human speech by using a word pronounced *krón* seems very natural.** Translating the first word of the Book of Odes into English with a term referring to sexual penetration would not only read bizarrely but be philologically gratuitous. (It might have helped with sales, perhaps.)

This also piqued my interest.
While it may be true that these words were somewhat interchangeable, in single syllables, it is still a bit harder to argue that the same goes for the reduplicated form, especially if we're dealing with SOUND ideophones, who usually display IMAGIC ICONICITY (cf. all the literature on ideophones ever in the last ten years or so, but also e.g. Dingemanse 2012; Thompson 2019).

But let's follow the argument okay, and compare with some advances in the reconstruction of Old Chinese phonology.
The table below shows the Mandarin, Middle Chinese (Baxter 1992) and Old Chinese (Baxter & Sagart 2014; B&S) as [it is found on their website](http://ocbaxtersagart.lsait.lsa.umich.edu), unless otherwise indicated.

character | Mandarin | Middle Chinese | Old Chinese | source
----------|----------|----------------|-------------|-------
關(关)    | guān     | kwaen          | [k]ˤro[n]   | B&S (2014)
關        | kwan1    |                | krón        | Sampson (2006; 2009)
          | guan     |                | kron        | Shaughnessy (2008)
          | guan     |                | kons        | Shaughnessy (2008)
貫        | kwan4    |                | kóns        | Sampson (2009)
貫        | guàn     | kwan           | [k]ˤo[n]-s  | B&S (2014)
管        | guǎn     | kwanX          | [k]ˤo[n]ʔ   | B&S (2014)
口管      | guān (?) | kwan (?)       | [k]ˤo[n\] (?) | ?

I tried ordering them according to the train of thought in this debate:
so first you have the current B&S transcription, basically *kˤron*, then Sampson's *krón*, followed by Shaughnessy's *krón* and possible formal variant *kons*, followed by Sampson's answer that that would be *kóns* in his system.
Next I give the B&S version of that *kons/kóns*, and the last two are suggestions I found in Legge (1871): that 關 is sometimes read as 管 or MOUTH(口)-管, 'flute'.
Personally, those last ones seem the most convincing for alternative characters of 關關: 管管 or (口管口管) 'flute flute', as in a sharp sound or so.

Now what does the biggest dictionary of Chinese I have access to say about 關關?
The *Hànyǔ dà cídiǎn* 漢語大詞典 says:

> 1.鳥類雌雄相和的鳴聲。 後亦泛指鳥鳴聲。   
Mating call of male and female birds.  
《詩‧周南‧關雎》： “關關雎鳩， 在河之洲。”   
  毛 傳： “關關， 和聲也。”   
  南朝 宋 鮑照 《代悲哉行》： “翩翩翔禽羅， 關關鳴鳥列。”   
  清 陸以湉 《冷廬雜識‧道情》： “只聽得流水潺潺， 鳥語關關。”    
>2.和諧安適貌。  
Harmonious.  
唐 錢起 《暇日覽舊詩因以題詠》： “逍遙心地得關關， 偶被功名涴我閒。”    
> 3.車行聲。  
Sound of carts passing.  
明 何景明 《憶昔行》： “明星迢迢車關關， 遙向 楚 水辭 燕 山。”

So, no 'beams' in sight -- maybe with some stretching you could argue for 'passing through (of carts)' and then that sound, but still mostly just the call of these mysterious birds.
Yes, you read that correctly, we don't actually really know what the bird is (or maybe now we do?, baidu and wikipedia do lead me to pictures), but the most common translation of *jūjiū* < tshjo kjuw < [tsʱ]a [k\]\(r\)u 雎鳩 is 'osprey' or 'fish-hawk'. 
Perhaps they are indeed a symbol of sex, because they eat fish, and fish are sexual symbols (Shaughnessy 2008).
Sampson (2009) notes that he just chose 'fish-hawk' because the osprey (apparently *Pandion haliaetus*) makes a very shrill sound, not very love-inspiring.
Perhaps this was also a case of the literature critic -- Shaugnessy -- reading too much into a pragmatic translation choice.

So for me in general, it seems Sampson is the winner in this debate, it's better to use *krón krón* (or maybe now *kˤron kˤron* if you want to be a Peter precise) than Mandarin *guānguān* or whatever translationese. 

But he's not entirely without faults either.
A grave example is when Shaughnessy discusses the merits of using the reconstructed Old Chinese (cf. above):

> \[...\] \(although I am not at all sure that for readers who do not know Chinese "*Krón, krón, tsa-kou*" Sampson’s reconstruction, is much to be preferred over "*Guan guan ju jiu*" the standard Romanization of the modern Chinese pronunciation\). 

To which Sampson responds:

>  If the line were considered in isolation like that, there would be little or no reason to prefer one pronunciation over the other; it takes two to tango, and **it certainly takes two lines of poetry to rhyme**. But the fact that the Book of Odes represents the first known use of rhyme anywhere in world literature is one of the fascinating things about it. So it would not be much use to an English-speaking reader to spell out the poems in a modern version of Chinese, in which the rhymes have been destroyed by three millennia of sound-change. **(In Old Chinese, tsa-kou, fish-hawk, in the first line rhymed with tou, islet, in the second line, but in modern Mandarin chü-chiu scarcely rhymes with chou.** In other cases the original rhymes, assonances, and so forth have been even more thoroughly wrecked in the modern language.)

I've highlighted two parts: Sampson is right of course, the *Shījīng* is one of the prime examples of rhyme and has actually been super useful in reconstruction Old Chinese, see for instance this exciting research by List ([2017](https://link.springer.com/article/10.1186%2Fs40655-017-0021-8); [2019](https://pure.mpg.de/pubman/faces/ViewItemOverviewPage.jsp?itemId=item_3149513)). 
On the other hand, he remarks that "chü-chiu scarcely rhymes with chou", which is a very strange remark to make, as *jūjiū* [tɕy˥ tɕjoʊ˥] of course rhymes with *zhōu* [ʈʂoʊ˥], there is not a hint of *scarcely* in sight. 

# The other ideophone

You thought this was *soro soro* (Jap. ソロソロ 'any time now') winding down, but no, not yet.

I want to draw attention to the second line of the first stanza as well, and compare again the different translations.

Line | Translator
-----|----------
窈窕淑女 | 
*yáotiáo shūnǚ* |
The **modest, retiring, virtuous**, young lady: —  | Legge (1871)
**Lovely** is this noble lady, | Waley (1937)
the **beautiful and good** girl, | Karlgren (1950)
A girl who is **lovely and good** | Sampson (2006)
  |  |
君子好逑 |
*jūnzi hǎo qiú* |
For our prince a good mate she. | Legge (1871)
Fit bride for our lord. | Waley (1937)
she is a good mate for the lord. | Karlgren (1950)
Is the fit match for a princely man. | Sampson (2006)

Of course, I argue that this *yáotiáo* 窈窕 is also an ideophone, more precisely one that expresses EVALUATION based on VISION: 
the lady (*shūnǚ* 淑女) is evaluated as lovely, beautiful, good, befitting the lord or gentlemen (*jūnzi* 君子).
Or, as it's found in the Chinese Ideophone Database [CHIDEOD](https://simazhi.shinyapps.io/Chineseideophone/):

> of women, coy and comely, reticent and withdrawn, winsome but withdrawn, delicate and demure; but some indication that the term can instead imply seductive sensuality; covert depths, hidden recesses; quiet(ly) and private(ly)
(Kroll 2015)

*Yáotiáo* thus conforms to the crosslinguistic concept of an ideophone: it is marked (partial reduplication), a word ("listable in a lexicon"), that depicts ("not just describes") a sensory image ("beautiful, lovely woman") and belongs to an open lexical class, cf. Dingemanse (2012; 2019). 

But do the translations above also conform what this ideophone depicts? Without taking into account factors like adhering to a metrical scheme (eight syllables or something similar), my preference without doubt goes to Legge's translation, because he captures the antithetical forces of "wanting to depict but being only able to describe" the best:
English doesn't have any ideophones (as far as I'm aware) to depict the kind of women that befits this lord.

But perhaps you won't agree. 
Let me know.

# The end?

Anyway, let me just end with the best mix-and-match of this stanza, or how I would do it, given a somewhat academic audience and enough space, i.e. here on my blog.

First I would give Baxter & Sagart's reconstruction:

> [k]ˤro\[n\] [k]ˤro\[n] [tsʱ]a [k]\(r\)u  
[dz]ˤəʕ [C.g]ˤaj tə tu   
ʔˤ[e]wʔ lˤ[e]wʔ s-tiwk nraʔ  
C.qur tsəʔ qʱˤuʔ g(r)u  

Then I would give the Middle Chinese reconstruction, instead of Baxter (1992), I would opt for the IPA version (I converted with [Sinopy](https://pypi.org/project/sinopy/)):

>kwæn kwæn ʦʰjo kjuw¹  
ʣoj² ɣa ʨi ʨuw¹  
ʔew² dew² ɕuwk ɳjo³  
kjun ʦi² xaw³ gjuw¹  

Last I would provide the Mandarin pronunciation:

> guānguān jūjiū  
zài hé zhī zhōu  
yǎotiǎo shūnǚ  
jūnzi hǎo qiú  

This way you can kind of see how sounds change, as well as the way people perceive the "sounds of the *Shījīng*.
Of course, we would need characters as well:

>關關雎鳩，  
在河之洲。  
窈窕淑女，  
君子好逑。   

And I would end with a translation:

> *Krōn, krōn* the físh-hawks cáll,  
ón the íslet ín the ríver.  
délicáte, demúre, young lády,  
fór the lórd a góód mate shé.

Of course I borrowed from previous translations, but I also tried to mark the prosody so there's four stressed syllables in the metre of each line. 
This, I think, is a more effective way of trying to marry the original four beat Chinese to English (where pentameter is the most frequent verse form).

**Didn't like the translation?**
**Make me a better one!**

I hope to see you back for the next update where we attack the problem of this verse and Chinese word segmentation.

P.s. I have been quite lazy with my references, but if you want a specific reference, feel free to ask.

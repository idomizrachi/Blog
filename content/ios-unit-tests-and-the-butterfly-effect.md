title: Unit tests and the butterfly effect

subtitle: This is a little longer description available on each post

tags: iOS, Swift, Unit Tests, Generics

date: 2022-06-14

---

### Remarks

---

*111Audiance*: iOS developers - mid to senior level
What is the problem/pain:
    Changes in code are fragile
**What do I want to share:**
    Unit tests takes some time to set up and get use to
    but when it works it saves time and prevents bugs
    We need to be able to move fast

XXX<br><br>



XXX

What we can't do/won't do:
We can not perform full ma regression testing on every feature

Unit tests should run fast and test a small part of logic

Meet our hero....
oh no...
conflict - changes are pain

what can he do?
X to the rescue

What did we achived - no more fear of changes


https://giphy.com/gifs/fail-pyramid-collapse-PtuayrkI1dKYo

Content
-------

Thursday night, the phone rings someone asks for a small changes in the app
that should only take few minutes.
I do it.... 
release

and .... crisis

luckliy we have unit tests

in the end - i drank my cup of wine 

# Apples and Butterflies
Our story begin on Friday night.

Me and my wife got ready for a fun movie night, the pizza was hot and the wine was cold.

<figure class="video_container">
  <video alt="Hungry Date Night GIF by Paperless Post" src="https://media4.giphy.com/media/ZDEDeQMqjm5oOygzgb/giphy.mp4?cid=790b761150ff00760f21ffd804d0f0d369112ab1eafa031e&amp;rid=giphy.mp4&amp;ct=g" poster="https://media4.giphy.com/media/ZDEDeQMqjm5oOygzgb/giphy_s.gif?cid=790b761150ff00760f21ffd804d0f0d369112ab1eafa031e&amp;rid=giphy_s.gif&amp;ct=g" autoplay="" loop="" playsinline="" style="width: 500px; height: 500px; left: 0px; top: 0px;"></video>
</figure>

and then **the phone rang**.

> Hey Ido, we need this very very very small fix in the mobile app for like tomorrow morning.
can you make it please, be our savior, the customer really really really need this fix...

![Puss in boots](https://media.giphy.com/media/V3TtZ4IWyVZgk/giphy.gif)

> Well, ok I answered, I will do it right away.

I sat down by the laptop, "This doesn't sound too complicated", I thought to myself.

![One Hour Later](https://i.ytimg.com/vi/MXcMV-d_2Js/maxresdefault.jpg)

The issue was done, quick sanity check and release, right?

**It was a very short article if it was right**

3 Hours later the phone rang again to find out that this very very very small fix caused a big issue in some area I would have never think it could effect, but it did.

If only there was some way to guard us from these kind of events?
There is.... and luckily this story is fictional, and in my daily routine I write and run Unit Tests & Automation Tests a lot.

For now lets focus on Unit Tests.

```
[09:35:14]: ▸ Test Succeeded
+--------------------+------+
|       Test Results        |
+--------------------+------+
| Number of tests    | 5794 |
| Number of failures | 0    |
+--------------------+------+
```

Yes, 5794 (at the time writing this article)

## Unit Tests, for a mobile app? Seriously, I can just test it manually in 5 minutes

This might be true if the mobile app is small, but as the app gets bigger in code base and features a complete manual testing cycle can take several days.

It seems to me that unit tests for mobile app are not a consensus yet.

Assuming most of us already working on existing app or code base, the first challenge is adding unit tests for the first time.

Unit tests has some prerequisites that takes time to implement, but it doesn't mean that the case should be **all** or **none**.

Some of the existing code might not built for testing, and changing it might be a little tricky.
The main pattern I use to allow components to be tested is *Dependency Injection*.

## But writing tests takes time

Yes, it is true.
Writing tests takes time, sometimes it can even take longer than the time it took to write the code it is testing.
But it is a time well invested in the future of the code base.

## Unit Tests saves me money?

We all know that time is money.

Every test we add will run in the future on every code change.
When an issue will be found by a unit test, it is caught in an early stage of the development, what usually makes it easier to fix.
Comparing issue found by unit tests to tracing an issue on an end-user after the app was released, or even compared to feedback from the QA team unit tests are much faster to trace and fix.

So unit tests saves time which also means they save money (developers / qa time has a cost).



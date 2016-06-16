# meLikee
meLikee is a parody dating app. It plays random audio pick-up lines from a Cloudkit database from premade profiles.
It is currently in beta-testing, so if you'd like to try it, email me! nazarioricardo@gmail.com.

## Why?
Because it's healthy to step back and laugh sometimes!

## But really, why?
I decided to make meLikee as a challenge to myself. I took myself out of my comfort zone by coming up with an app--with some help from my friends--that wasn't limited by what I already knew I could make. Instead, building meLikee forced me to learn some useful skills. Like how to design a database and  how to download audio and image files from a server and present them cleanly and reliably on an iPhone. And because the app is a parody, I didn't have to worry about coming up with something that is useful in a concrete way.

## What kind of code can I find here?
If you're looking to gain insight on how to manage database information using structs with Objective-C try checking out the
code in the models folder of the Xcode workspace.

There are some useful Cloudkit methods in the CloudkitManager singleton in the controls folder. Such as an algorithm that finds the number of records from a record type in order to fetch a random record. Cloudkit doesn't currently have a method 
that returns only the count of a record type, nor a method that fetches a random record.

Other than that it is all pretty standard!

https://youtu.be/s1JPEb5pYt4

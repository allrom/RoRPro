# README

This application was being developed when studying the Ruby-on-Rails basic and advanced principles and techs It's intnded to simulate "question & answers" site dynamic behavior.

![Question and answer site Demo](../demo_assets/demo/ror-pro.gif?raw=true) 
* __Ruby version 2.5.1p57__

* Bundle with 2.0.1

* __App Server__
  - test & development: Puma
  - production: Unicorn, Passenger

<details>
<summary>Configuration</summary>
  
+ rails 5.2.3
+ rack 2.0.7
+ slim 4.0.1
+ cocoon 1.2.14
+ thinking-sphinx 4.4.1
+ capybara 3.29.0
+ rspec-core 3.8.2
+ rspec-rails 3.8.2
</details>
  
<details>
<summary>Authentication</summary>
  
+ gem devise
+ gem omniauth
   + gem omniauth-github
   + gem omniauth-vkontakte
</details>
     
* Authorization
   -  gem cancancan

  
* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment was being performed to _ScaleWay Cloud_
  (Appliance is being offline now, but can be started on demand) 

<hr>
Test Study Project 06 - 12.2019, <span>&#169;</span> Thinknetica

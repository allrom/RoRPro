# README

This application was being developed when studying the ***Ruby-on-Rails basic and advanced principles and techs***. It's intended to simulate "question & answers" site dynamic behavior (_StackOverflow_-alike). The development was carried out with principles of _Solo Agile_ and _TDD/BDD_ in mind.

![Question and answer site Demo](../demo_assets/demo/ror-pro.gif?raw=true) 

* __Ruby version 2.5.1p57__

* __Bundler version 2.0.1__

* __App Server__
  - test & development: _Puma_
  - production: _Unicorn, Passenger_

<details>
  <summary><b>Configuration</b></summary>
 
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
<summary><b>Authentication</b></summary>
  
+ gem devise
+ gem omniauth
   + gem omniauth-github
   + gem omniauth-vkontakte
</details>
     
* __Authorization__
   - gem cancancan
  
* __Database info__
  > Application uses _PostgreSQL_ as its database server (devel & production). 

### Application Features



<details>
<summary><b>About the test suite</b></summary>
  
- These are some gems that do needed\helped to perform effective testing with _Rspec_:

   + gem capybara
   + gem selenium-webdriver
   + gem rspec-rails
   + gem letter-opener
   + gem shoulda-matchers
   + gem launchy
   + gem capybara-email
   + gem with_model
 
 - **Acceptance and integration** tests have been written to check if the app works well from the user's
 perspective: creation, editing, deleting of questions and answers, adding links or attach files, voting,
 searching, selecting the best answer, giving awards.
 - **Unit** tests have been written to test different parts of application in isolation: controllers,
 models, services, mailers.
 - **To run** a full bunch (more than 500) of tests, invoke the following from the app working directory:
 > $rspec spec/ 
</details>   

* __Services__ (job queues, cache servers, search engines, etc.)

* __Deployment__ 
 Was being performed to _ScaleWay Cloud_.
 (_Virtual appliance_ is being offline now, but can be started on demand as live demo) 

<hr>
Test Study Project 06 - 12.2019, <span>&#169;</span> Thinknetica

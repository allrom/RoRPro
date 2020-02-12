# README

### Abstract
This application was being developed when studying the ***Ruby-on-Rails basic and advanced principles and techniques***. It's intended to construct __QA__ dynamic site (_StackOverflow_-alike) with the wide set of
abilities, including authentication, services integration with OAuth, posting comments, subscribing to updates,
full-text searching, attaching and storing files in a  S3 Cloud. The development was carried out with principles
of _Solo Agile_ and _TDD/BDD_ in mind. User interface pages were designed using custom CSS and JavaScript.

![Question and answer site Demo](../demo_assets/demo/ror-pro.gif?raw=true) 

### Composition
* __Ruby version 2.5.1p57__

* __Bundler version 2.0.1__

* __App Servers__
  - test & development: _Puma_
  - production: _Unicorn, Passenger_
  
* __Web Server__
  - production: _Nginx_  

<details>
  <summary><b>Configuration</b></summary>
  
 - The main set
  
    + rails 5.2.3
    + rack 2.0.7
    + pg 1.1.4
    + slim 4.0.1
    + cocoon 1.2.14
    + thinking-sphinx 4.4.1
    + unicorn 5.5.1
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
  
* __Database info__
  > Application uses _PostgreSQL_ as its database server (devel & production). 

### Application Features

<details>
<summary><b>About the test suite</b></summary>
  
- These are some gems that do needed\helped to perform effective testing with _Capybara_ and _Rspec_:

   + gem capybara
   + gem selenium-webdriver
   + gem rspec-rails
   + gem factory_bot_rails
   + gem letter-opener
   + gem shoulda-matchers
   + gem launchy
   + gem capybara-email
   + gem with_model
 
 - **Acceptance/integration** tests have been written to check if the app works well from the user's
 perspective: creation, editing, deleting of questions and answers, adding links or attach files, voting,
 searching, adding subscription or comment, selecting the best answer, giving awards.
 - **Unit/System** tests have been written to test different parts of application in isolation: controllers,
 models, services, mailers.
 - **To run** a full bunch (more than __500__) of tests, invoke the following from the app working directory:
 > $rspec spec/ 
</details>   

<details>
<summary><b>Services and Building blocks</b></summary>
<br>
  
  - ActiveStorage (store files locally or in _S3 bucket_, gem mini_magick)
  - Nested forms (gem cocoon)
  - Slim / Skim (template editors, gems slim-rails, skim)
  - ActionCable (built-in, as pub/sub model)
  - Authentication, registering (gem devise) 
  - OAuth (cross-app authentication, gems omniauth, -github, -vkonakte)
  - CanCanCan (authorization in app, gem cancancan)
  - Background job processing (gems sidekiq, whenever)
  - Sphinx engine (full-text indexed search, gem thinking-sphinx)
  - REST API as an internal project (gems doorkeeper, active_model_serializers, oj)
  - Application deployment (gems capistrano, -passenger, -unicorn, -sidekiq)
</details>  

* __Optimization__
  - App page fragment caching (_Redis_ cache store with _hiredis_ driver)
  - Background app tasks offload proccessing (_Sidekick_ jobs as _crontab_ scheduler members)

* __Deployment__ 
  - Was being performed to _ScaleWay Cloud_.
  (_Virtual appliance_ is being offline now, but can be started on demand as live demo) 

<hr>

__QA site Project 06 - 12.2019, <span>&#8482;</span> Thinknetica__

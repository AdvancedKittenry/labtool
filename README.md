labtool
=======

http://tktl-labtool.herokuapp.com/

Ohjelmoinnin harjoitustyön ohjaajan työkalu

Asiakkaan toivomat ominaisuudet:
- https://github.com/mluukkai/labtool/issues
- vanha toivottujen featurejen lista https://github.com/mluukkai/labtool/wiki/feturet

Käyttöohjeita:

- opiskelija 
  - ilmoittautuu ensin sivulle http://tktl-labtool.herokuapp.com/register
  - käyttää järjestelmää tämän jälkeen sivun http://tktl-labtool.herokuapp.com/mypage kautta
  - opiskelija ei siis kirjaudu järjestelmään
- admin-käyttäjätunnukset tuotu labraohjaajille
  - email-osoite on Ilmoon rekisteröimäsi ja salasanana opiskelijanumerosi
- admin käyttää ylhäällä olevan valikon sivuista normaalisti vaan seuraavia:
  - peer reviews: sisältää koodikatselmoinnin generoinnin
  - current course: sisältää kaiken muun menossa olevan kurssin kannalta olellisen (mm. ilmottautuneet)
- harvemmin käytettäviä sivuja:
  - courses: uusien kurssiinstanssien luonti, ja vanhojen tiedot ja niiden muutokset
  - registrations: ilmoittautumiset, sekä nykyiset että menneet
  - users: joskus ilmoittautuneiden käyttäjien tiedot

Asennus:

Asennetaan kuten normaali rails-sovellus.
Muista ajaa rake bootstrap:all, joka laittaa kantaan oletuskäyttäjän ja kurssin.

Koodin laadunvalvonta:

[![Build Status](https://travis-ci.org/mluukkai/labtool.png)](https://travis-ci.org/mluukkai/labtool)
[![Code Climate](https://codeclimate.com/github/mluukkai/labtool.png)](https://codeclimate.com/github/mluukkai/labtool)

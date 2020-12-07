# Labo 4: Intro scripting

Als je gebruik maakt van andere bronnen (bv. blog-artikel of HOWTO die je op het Internet vond), voeg die dan toe aan het einde van dit document. Zo kan je het later makkelijk terug vinden.

Maak ter voorbereiding zeker de oefeningen in Linux Fundamentals (Paul Cobbaut) over dit onderwerp (pp. 97, 174 en 181).

## Variabelen

Geef zoals gewoonlijk het commando om de opgegeven taak uit te voeren en controleer ook het resultaat.

1. Druk met behulp van de juiste systeemvariabele de gebruikte bash-versie af op het scherm. Geef het gebruikte commando weer.
    ```
    $ echo $BASH_VERSION
    ```
2. Je bent ingelogd als gewone gebruiker.
    1. Maak een variabele `pinguin` aan en geef deze de waarde Tux.
        ```
        $ pinguin="Tux"
        ```
    2. Hoe kan je de inhoud opvragen van deze variabele en afdrukken op het scherm?
        ```
        $ echo $pinguin
        ```
    3. Open nu een sub(bash)shell in je huidige bashomgeving.
        ```
        $ echo $(<commando uit te voeren in subshell>)
        ```
    4. Hoe kan je controleren dat er nu twee bashshells actief zijn en dat de ene een subshell is van de andere?

        *Variabel BASH_SUBSHELL = 0 in main shell en zal in subshell = 1.*
        ```
        $ echo $(echo $BASH_SUBSHELL)
        ```
    5. Probeer nu in deze nieuwe subshell de inhoud van de variabele PINGUIN af te drukken op het scherm. Lukt dit?
    
        *Nee.*

    6. De verklaring hiervoor ligt in het type variabele. Welke soort variabele is PINGUIN en hoe kan je dit controleren? Keer hiervoor terug naar je oorspronkelijke bashshell

        *PENGUIN is local variable, bestaat dus niet in de subshell enkel*

    7. Zorg er nu voor dat de inhoud van PINGUIN ook in elke nieuwe subshell kan gelezen worden? Hoe doe je dit? Schrijf het gebruikte commando neer.
        ```
        $ export pinguin
        ```
    8. Open opnieuw een sub(bash)shell in je huidige bashomgeving en controleer of je nu de inhoud van PINGUIN kan lezen. Welk soort variabele is PINGUIN nu? Doe dan ook de controle.

        *Global variable.*
        ```
        $ echo $(echo $pinguin)
        ```
3. Zoek de inhoud op van volgende shellvariabelen en vul volgende tabel aan:

    | Variabele  | Waarde |
    | ---------- | ------ |
    | `PATH`     | /home/\<user\>/.local/bin:/home/\<user\>/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin |
    | `HISTSIZE` | 1000 |
    | `UID`      | 1000 |
    | `HOME`     | /home/\<user\> |
    | `HOSTNAME` | localhost.localdomain |
    | `LANG`     | en_US.UTF-8 |
    | `USER`     | \<user\> |
    | `OSTYPE`   | linux-gnu |
    | `PWD`      | /home/\<user\> |
    | `MANPATH`  | geen waarde |

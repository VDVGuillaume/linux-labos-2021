# Labo 6: Variabelen en scripts

Als je gebruik maakt van andere bronnen (bv. blog-artikel of HOWTO die je op het Internet vond), voeg die dan toe aan het einde van dit document. Zo kan je het later makkelijk terug vinden.

Maak ter voorbereiding zeker de oefeningen in Linux Fundamentals (Paul Cobbaut) over dit onderwerp (pp. 97, 174 en 181).

Voor sommige van de opgaven zijn er unit tests voorzien die je een aanwijzing geven of je op de goede weg zit. De bedoeling is dat je de gevraagde scripts in de subdirectory `labo6` opslaat. Als je je in directory `labo6` bevindt, kan je de tests uitvoeren met:

```
$ tests/runtests.sh
Installing ShellCheck. Please enter your sudo password!
[sudo] password for user: 
Last metadata expiration check performed 0:02:24 ago on Tue Oct 20 14:05:56 2015.
Dependencies resolved.

... [installatie ShellCheck en BATS]

Running test /home/user/scripts/tests/01-onderelkaar.bats
 ✗ Het script onderelkaar.sh moet bestaan
   (in test file tests/01-onderelkaar.bats, line 10)
     `[ -f "${script}" ]' failed
 ✗ Het script moet uitvoerbaar zijn
   (in test file tests/01-onderelkaar.bats, line 14)
     `[ -x "${script}" ]' failed

... [meer uitvoer van het testscript]
```

Indien nodig wordt bij het voor de eerste keer uitvoeren van het testscript het Unit-testframework voor Bash, [BATS](https://github.com/sstephenson/bats), geïnstalleerd en ook de statische analysetool [ShellCheck](https://www.shellcheck.net/).

De unit tests van de oefeningen worden in volgorde uitgevoerd. Zolang er nog fouten in een oefening gevonden zijn, worden de tests van de volgende nog niet uitgevoerd.

1. Maak een script met de naam `onderelkaar.sh` die de op de command line als argumenten ingevoerde zin woord per woord onder elkaar afdrukt op het scherm. Als de gebruiker geen argumenten opgegeven heeft, wordt er een gepaste foutboodschap op stderr afgedrukt en stopt het script met een foutcode (exit-status verschillend van 0). Voorbeeld van de uitvoer:

    ```
    $ ./onderelkaar.sh dit is een test
    dit
    is
    een
    test
    $ echo $?
    0
    $ ./onderelkaar.sh
    Geen argumenten opgegeven!
    $ echo $?
    1
    ```
    
    ```bash
    #/bin/bash

    # Print args onder elkaar
    if [[ $# -gt 0 ]]; then
            for ARG in $@; do
                    echo "${ARG}"
            done
    else
        echo "Geen argumenten opgegeven!" >&2
            exit 1
    fi
    ```

2. Schrijf een script `gebruikerslijst.sh` dat een gesorteerde lijst van users (uit `/etc/passwd`) weergeeft op het scherm. Maak gebruik van het het commando `cut`.
    ```bash
    #/bin/bash

    # Gesorteerde lijst van users
    echo "$(cut -d: -f 1 /etc/passwd | sort)"
    ```

3. Schrijf een script `elf-params.sh` dat werkt zoals `onderelkaar.sh`, maar maximaal 11 parameters afdrukt. Extra parameters worden genegeerd.  Positionele parameters en `shift` zijn een tip.
    ```bash
    #/bin/bash

    # Print eerste 11 parameters
    COUNTER=0

    while [[ $COUNTER -lt 11 && $# -ne 0 ]]; do
            echo "$1"
            COUNTER=$((COUNTER+1))
            shift
    done
    ```

4. Schrijf een script `datum.sh` dat het aantal elementen van het commando `date` weergeeft en daarna al de elementen onder elkaar. Maak gebruik van positionele parameters en het `set` commando. Gebruik ook een `while`-lus.
    ```bash
    /bin/bash

    # Print date output onder elkaar
    set $(date)

    echo "Aantal elementen: $#"
    echo

    while [[ $# -gt 0 ]]; do
            echo "$1"
            shift
    done
    ```

5. Vraag aan de gebruiker van dit script een naam voor een bestand, schrijf dit vervolgens weg en zorg ervoor dat het bestand uitvoerbaar is. (opm. geen unit tests)
    ```bash
    #/bin/bash

    clear
    echo -n "Geef naam voor bestand:"
    echo
    read FILE

    # Create file
    touch "${FILE}"

    # Permissions
    chmod u+rwx "${FILE}"
    ```

6. Dit script zal een bestand kopiëren. Bron en doel worden als argumenten meegegeven. Test of het doelbestand bestaat. Indien wel, wordt het script afgebroken. (Opm. geen unit tests voor deze oefening)
    ```bash
    #/bin/bash

    FILE="$1"
    DOEL="$2"

    # Test bestaat doel reeds
    if [ -f "${DOEL}" ]; then
            echo "${DOEL} bestaat al!"
            exit 1
    fi

    cp "${FILE}" "${DOEL}"
    ```

7. Sorteer de inhoud van een bestand (arg1) en toon de laatste regels (aantal regels = arg2). Indien argument 1 ontbreekt, melding geven en afbreken. Indien argument 2 ontbreekt neemt men 20 als default waarde. Om te testen maak je een bestand aan met alle letters van het alfabet, in de volgorde van je toetsenbord. (Opm. geen unit tests voor deze oefening)
    ```bash
    #/bin/bash

    FILE="$1"

    if [! -f "${FILE}" ]; then
            echo "${FILE} is geen bestand of bestaat niet!"
            exit 1
    fi

    if [ $# -eq 2  ]; then
            REGELS="$2"
    else
            REGELS=20
    fi

    echo "$(sort ${FILE} | tail -n ${REGELS})"
    ```

8. Dit script moet testen of een bestand (opvragen aan gebruiker) bestaat en uitvoerbaar is, indien niet, moet het uitvoerbaar gemaakt worden.
    ```bash
    #/bin/bash

    FILE="$1"

    # Test bestaat bestand
    if [ -e "${FILE}" ]; then

            # Test bestand uitvoerbaar
            if [ ! -x "${FILE}" ]; then

                    chmod u+x "${FILE}"
            fi
    else
            echo "Bestand bestaat niet!"
    fi
    ```

9. Dit script maakt gebruik van het cal (kalender commando). De gebruiker wordt verplicht om de drie eerste letters van de maand (jan-feb-maa-apr-mei-jun-jul-aug-sep-okt-nov-dec) in te geven. Geef foutmelding indien geen correcte maand wordt ingegeven en stop het script. De gebruiker kan ook het jaartal ingeven (niet verplicht). Indien niet ingegeven wordt het huidige jaar gebruikt.
    ```bash
    #/bin/bash

    clear

    MAAND=""

    while [ -z "${MAAND}" ]; do
            echo -n "Geef de drie eerste letters van een maand in?"
            echo
        read MAAND
    done

    echo -n "Geef een jaartal in? (Optioneel)"
    echo
    read JAAR

    if [ -z "${JAAR}" ]; then
            JAAR=$(date +%Y)        # +%Y format geeft enkel jaar
    fi

    case ${MAAND} in
            jan) MON=1;;
            feb) MON=2;;
            maa) MON=3;;
            apr) MON=4;;
            mei) MON=5;;
            jun) MON=6;;
            jul) MON=7;;
            aug) MON=8;;
            sep) MON=9;;
            okt) MON=10;;
            nov) MON=11;;
            dec) MON=12;;
            *) echo "Foutieve maand";
                    exit;;
    esac

    cal ${MON} ${JAAR}
    ```

## Gebruikte bronnen

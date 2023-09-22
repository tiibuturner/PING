
## Tiina Ylimäki
## Tehtävänanto:
## 1. Lue webpages.txt tiedot RF:n käyttöön.
## 2. Lähetä Ping jokaiseen tekstitiedostolta löytyvään osoitteeseen.
## 3. Ota RF:llä talteen jokaisen pingattavan sivuston IP ja pinggiin kuluva aika. Testaa, että Pingiin kuluva aika on alle 50ms.
## 4. Luo uusi txt-tiedosto johon kirjoitat pingatun sivuston IP-osoitteen ja pingiin kuluneen keskimääräisen ajan.


*** Settings ***
Library    OperatingSystem
Library    String
Library    Collections

*** Test Cases ***
Read File.

    ## Lue webpages.txt tiedot RF:n käyttöön.

    ${path}    Set Variable    C:/Users/Omistaja/OneDrive/Työpöytä/HAMK/2023/Syksy2023/Asiakasprojektien toteuttaminen/Ohjelmistotestaus/pingtehtava
    ${content}=    Get File    ${path}/webpages.txt
    @{addresses}=   Split String    ${content}
    Log    Contents of txt-file:\n ${addresses}

    ## Tehdään muuttujasta globaali, jotta sitä voi käyttää myöhemminkin.

    Set Global Variable    ${addresses}

*** Test Cases ***
Create new file.
    ## Luo uusi txt-tiedosto, jonne IP:t ja ajat laitetaan.
    ${path}=    Set Variable    C:/Users/Omistaja/OneDrive/Työpöytä/HAMK/2023/Syksy2023/Asiakasprojektien toteuttaminen/Ohjelmistotestaus/pingtehtava
    
    ## Luodaan uusi kansio.
    
    Create File    ${path}/osoitteet.txt

    ## Tsekataan, että kansio on luomisen jälkeen olemassa ja että se on tyhjä.

    File Should Exist    ${path}/osoitteet.txt
    File Should Be Empty    ${path}/osoitteet.txt

*** Test Cases ***
Calculate.
    ${path}=    Set Variable    C:/Users/Omistaja/OneDrive/Työpöytä/HAMK/2023/Syksy2023/Asiakasprojektien toteuttaminen/Ohjelmistotestaus/pingtehtava
    ${count}=    Get Length       ${addresses}
    FOR    ${address}    IN RANGE    ${count}

    ## Lähetetään Ping jokaiseen tekstitiedostolta löytyvään osoitteeseen.
    
        ${output}=    Run And Return Rc And Output    ping ${addresses}[${address}]
        @{wordList}=    Split String    ${output}[1]

    ## Haetaan indeksi ja tallennetaan se muuttujaan.

        ${index}=    Get Index From List    ${wordList}    Pinging
        ${index}=    Evaluate    ${index}+2
        ${IPAddress}=    Set Variable    ${wordList}[${index}]

    ## PINGin keskiarvoaika, tallennetaan sekin muuttujaan.
    
        ${index}=    Get Index From List    ${wordList}    Average
        ${index2}=    Evaluate    ${index}+2
        ${Average}=    Set Variable    ${wordList}[${index2}]

    ## Muutetaan formaatti numeroksi. Vertailu on siten helpompaa.

        ${AverageNumber}=    Set Variable    ${Average}[:-2]
        ${AverageNumberOnly}=    Convert To Number    ${AverageNumber}

    ## Vertailu.

        Should Be True    ${AverageNumberonly} < 50.0

    ## Laitetaan IP-osoitteet aiemmin luotuun kansioon aikoineen.

        Append To File    ${path}/osoitteet.txt    IP Address:${IPAddress}, Average: ${Average}\n
    END
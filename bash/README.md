# Automation Resources - Bash Script


## NOMENCLATURE

La nomenclature permet de connaitre la version du script, son statut d'implémentation ou le script appelé...

### Exemple de nomenclature

```
- php : [php_install.sh][v-1.0.0][active]
```
- Nom : [Script appellé] [Version] [État d'implémentation]


### Nomenclature du Statut Implémentation

- **[todo]** : Le script est indisponible, il est prévu de l'implémenter.
- **[in-progress]** : Le script est indisponible, il est en cours d'implémentation.
- **[testing]** : Le script est disponible mais son utilisation reste potentielement instable car il doit passer les étapes de tests.
- **[active]** : Le script est disponible, actif et fonctionnel.
- **[obsolete]** : Le script est disponible, actif et fonctionnel mais il est considéré comme obsolète.


---

## STRUCTURE DES SCRIPTS


### SCRIPTS PRINCIPAUX
---

```
./sauron.sh 
```

- Un script pour les lister tous, un script pour les commander tous et dans les ténèbres de l’informatique les réunir
- Permet d'accéder à la liste de tous les programmes d'installation et au utilitaires

---

### SCRIPTS PAR CATÉGORIES
---

```shell
./languages.sh
```

- scripts d’installation des langages


    |    NOM | SCRIPT | VERSION | STATUT |
    |--------|--------|---------|--------|
    |   php  | `./php_install.sh`   | v-1.0.0 | [in-progress] |
    |   node | `./node_install.sh`  | v-1.0.0 | [in-progress] |
    |   java | `./java_install.sh`  | v-1.0.0 | [todo] |
    |   C#   | `./csharp_install.sh`| v-1.0.0 | [todo] |
    |   c    | `./c_install.sh`     | v-1.0.0 | [todo] |
    |   c++  | `./cplus_install.sh` | v-1.0.0 | [todo] |
    |   ruby | `./ruby_install.sh`  | v-1.0.0 | [todo] |
    |   rust | `./rust_install.sh`  | v-1.0.0 | [todo] |
    |   dart | `./dart_install.sh`  | v-1.0.0 | [todo] |

---

```shell
./framework.sh
```

- scripts d’installation des frameworks

    |    NOM   |   SCRIPT  | VERSION | STATUT |
    |----------|-----------|---------|--------|
    |symfony   | `./symfony_install.sh`   | v-1.0.0 | [in-progress] |
    |laravel   | `./laravel_install.sh`   | v-1.0.0 | [todo] |
    |dotnet    | `./dotnet_install.sh`    | v-1.0.0 | [todo] |
    |dotnetCore| `./dotnetcore_install.sh`| v-1.0.0 | [todo] |
    |django    | `./django_install.sh`    | v-1.0.0 | [todo] |
    |express   | `./express_install.sh`   | v-1.0.0 | [todo] |
    |koa       | `./koa_install.sh`       | v-1.0.0 | [todo] |
    |qt        | `./qt_install.sh`        | v-1.0.0 | [todo] |
    |rubyOnRail| `./rubyonrail_install.sh`| v-1.0.0 | [todo] |
    |javaSpring| `./javaspring_install.sh`| v-1.0.0 | [todo] |
    |react     | `./react_install.sh`     | v-1.0.0 | [todo] |
    |vue       | `./vue_install.sh`       | v-1.0.0 | [todo] |
    |angular   | `./angular_install.sh`   | v-1.0.0 | [todo] |
    |vue       | `./vue_install.sh`       | v-1.0.0 | [todo] |


---

```shell
./lib_manager.sh
```

- scripts d’installation des programmes liés au gestionnaires de dépendances et bibliothèque

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |npm     | `./npm_install.sh`     | v-1.0.0 | [todo] |
    |yarn    | `./yarn_install.sh`    | v-1.0.0 | [todo] |
    |composer| `./composer_install.sh`| v-1.0.0 | [todo] |
    |entity  | `./entity_install.sh`  | v-1.0.0 | [todo] |
    |nuGet   | `./nuget_install.sh`   | v-1.0.0 | [todo] |
    |pip     | `./pip_install.sh`     | v-1.0.0 | [todo] |
    |pipTool | `./piptool_install.sh` | v-1.0.0 | [todo] |
    |pipEnv  | `./pipenv_install.sh`  | v-1.0.0 | [todo] |
    |poetry  | `./poetry_install.sh`  | v-1.0.0 | [todo] |
    |pipTool | `./piptool_install.sh` | v-1.0.0 | [todo] |
    |vcpkg   | `./vcpkg_install.sh`   | v-1.0.0 | [todo] |
    |conan   | `./conan_install.sh`   | v-1.0.0 | [todo] |
    |cargo   | `./cargo_install.sh`   | v-1.0.0 | [todo] |
    |rubyGems| `./rubygems_install.sh`| v-1.0.0 | [todo] |
    |pub     | `./pub_install.sh`     | v-1.0.0 | [todo] |
    
---

```shell
./cli.sh
```

- scripts d’installation des cli

    |     NOM    |   SCRIPT  | VERSION | STATUT |
    |------------|-----------|---------|--------|
    |symfony CLI | `./symfony_cli_install.sh`| v-1.0.0 | [todo] |
    |docker CLI  | `./docker_cli_install.sh` | v-1.0.0 | [todo] |
    
---

```shell
./api.sh
```

- scripts d’installation des programmes liés au tests

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |postman | `./postman_install.sh`| v-1.0.0 | [todo] |
    |strapi  | `./strapi_install.sh` | v-1.0.0 | [todo] |
    
---

```shell
./test.sh
```

- scripts d’installation des programmes liés au tests

    |     NOM    |   SCRIPT  | VERSION | STATUT |
    |------------|-----------|---------|--------|
    |phpUnit     | `./phpunit_install.sh`     | v-1.0.0 | [todo] |
    |jsUnit      | `./jsunit_install.sh`      | v-1.0.0 | [todo] |
    |nUnit       | `./nunit_install.sh`       | v-1.0.0 | [todo] |
    |dusk        | `./dusk_install.sh`        | v-1.0.0 | [todo] |
    |jenkins     | `./jenkins_install.sh`     | v-1.0.0 | [todo] |
    |puppeteer   | `./puppeteer_install.sh`   | v-1.0.0 | [todo] |
    |cyspress    | `./cyspress_install.sh`    | v-1.0.0 | [todo] |
    |playwright  | `./playwright_install.sh`  | v-1.0.0 | [todo] |
    |gitlabRunner| `./gitlabRunner_install.sh`| v-1.0.0 | [todo] |
    
---

```shell
./monitoring.sh
```

- scripts d’installation des programmes liés au monitoring

    |     NOM   |   SCRIPT  | VERSION | STATUT |
    |-----------|-----------|---------|--------|
    |grafana    | `./grafana_install.sh`   | v-1.0.0 | [todo] |
    |prometheus | `./prometheus_install.sh`| v-1.0.0 | [todo] |
    |matomo     | `./matomo_install.sh`    | v-1.0.0 | [todo] |
    |umami      | `./umami_install.sh`     | v-1.0.0 | [todo] |
    
---

```shell
./ide.sh
```

- scripts d’installation des IDE

    |     NOM     |   SCRIPT  | VERSION | STATUT |
    |-------------|-----------|---------|--------|
    |vscode       | `./vscode_install.sh`      | v-1.0.0 | [todo] |
    |visual studio| `./visualstudio_install.sh`| v-1.0.0 | [todo] |
    |eclipse      | `./eclipse_install.sh`     | v-1.0.0 | [todo] |
    |atom         | `./atom_install.sh`        | v-1.0.0 | [todo] |
    |sublime text | `./sublimetext_install.sh` | v-1.0.0 | [todo] |
    |php storm    | `./php_storm_install.sh`   | v-1.0.0 | [todo] |
    |vim          | `./vim_install.sh`         | v-1.0.0 | [todo] |
    |nano         | `./nano_install.sh`        | v-1.0.0 | [todo] |
---

```shell
./sdk.sh
```

- scripts d’installation des SDK

    |      NOM     |   SCRIPT  | VERSION | STATUT |
    |--------------|-----------|---------|--------|
    |fluter sdk    | `./fluttersdk_install.sh`   | v-1.0.0 | [todo] |
    |android studio| `./androidstudio_install.sh`| v-1.0.0 | [todo] |
    |inteliJ       | `./intelij_install.sh`      | v-1.0.0 | [todo] |
    
---

```shell
./database.sh
```

- scripts d’installation des programmes liés au base de donnée

    |    NOM   |   SCRIPT  | VERSION | STATUT |
    |----------|-----------|---------|--------|
    |mysql     | `./mysql_install.sh`     | v-1.0.0 | [todo] |
    |mariaDb   | `./mariadb_install.sh`   | v-1.0.0 | [todo] |
    |postgresql| `./postgresql_install.sh`| v-1.0.0 | [todo] |
    |mongoDb   | `./mongodb_install.sh`   | v-1.0.0 | [todo] |
    |sqLite    | `./sqlite_install.sh`    | v-1.0.0 | [todo] |
    |workbench | `./workbench_install.sh` | v-1.0.0 | [todo] |
    |phpMyAdmin| `./phpmyadmin_install.sh`| v-1.0.0 | [todo] |
    |adminer   | `./adminer_install.sh`   | v-1.0.0 | [todo] |
    |pgAdmin   | `./pgadmin_install.sh`   | v-1.0.0 | [todo] |
    |phpPgAdmin| `./phppgadmin_install.sh`| v-1.0.0 | [todo] |
    |deBeaver  | `./debeaver_install.sh`  | v-1.0.0 | [todo] |
    |franchise | `./franchise_install.sh` | v-1.0.0 | [todo] |
    |noCoDB    | `./nocodb_install.sh`    | v-1.0.0 | [todo] |
    |noCoDB    | `./nocodb_install.sh`    | v-1.0.0 | [todo] |
    |baseRow   | `./baserow_install.sh`   | v-1.0.0 | [todo] |
    |supabase  | `./supabase_install.sh`  | v-1.0.0 | [todo] |
    |baseRow   | `./baserow_install.sh`   | v-1.0.0 | [todo] |
    
    
---

```shell
./versionning.sh
```

- scripts d’installation des programmes liés au versionning

    |    NOM   |   SCRIPT  | VERSION | STATUT |
    |----------|-----------|---------|--------|
    |git       | `./git_install.sh`   | v-1.0.0 | [todo] |
    |gitlab    | `./gitlab_install.sh`| v-1.0.0 | [todo] |
    
---

```shell
./com.sh
```

- scripts d’installation des programmes liés à la communication

    |      NOM    |   SCRIPT  | VERSION | STATUT |
    |-------------|-----------|---------|--------|
    |discord      | `./discord_install.sh`      | v-1.0.0 | [todo] |
    |slack        | `./slack_install.sh`        | v-1.0.0 | [todo] |
    |teams        | `./yteams_install.sh`       | v-1.0.0 | [todo] |
    |skype        | `./skype_install.sh`        | v-1.0.0 | [todo] |
    |rocket Chat  | `./rocketchat_install.sh`   | v-1.0.0 | [todo] |
    |zulip        | `./zulip_install.sh`        | v-1.0.0 | [todo] |
    |jitsi        | `./jitsi_install.sh`        | v-1.0.0 | [todo] |
    |bigbluebutton| `./bigbluebutton_install.sh`| v-1.0.0 | [todo] |
    
---

```shell
./automation.sh
```

- scripts d’installation des programmes liés à l’automation

    |    NOM   |   SCRIPT  | VERSION | STATUT |
    |----------|-----------|---------|--------|
    |ansible   | `./ansible_install.sh`   | v-1.0.0 | [todo] |
    |terraform | `./terraform_install.sh` | v-1.0.0 | [todo] |
    |chef      | `./chef_install.sh`      | v-1.0.0 | [todo] |
    |jenkins   | `./jenkins_install.sh`   | v-1.0.0 | [todo] |
    |puppeteer | `./puppeteer_install.sh` | v-1.0.0 | [todo] |
    |n8n       | `./n8n_install.sh`       | v-1.0.0 | [todo] |
    |flogo     | `./flogo_install.sh`     | v-1.0.0 | [todo] |
    |node red  | `./nodered_install.sh`   | v-1.0.0 | [todo] |
    
---

```shell
./server.sh
```

- scripts d’installation des programmes liés à la gestion serveur

    |    NOM   |   SCRIPT  | VERSION | STATUT |
    |----------|-----------|---------|--------|
    |webmin    | `./webmin_install.sh`    | v-1.0.0 | [todo] |
    |cockpit   | `./webmin_install.sh`    | v-1.0.0 | [todo] |
    |ajenti    | `./ajenti_install.sh`    | v-1.0.0 | [todo] |
    |cyberpanel| `./cyberpanel_install.sh`| v-1.0.0 | [todo] |
    |froxlor   | `./froxlor_install.sh`   | v-1.0.0 | [todo] |
    |apache    | `./apache_install.sh`    | v-1.0.0 | [todo] |
    |nginx     | `./nginx_install.sh`     | v-1.0.0 | [todo] |
    |ASP DotNet| `./aspdotnet_install.sh` | v-1.0.0 | [todo] |
    
---

```shell
./deploiement.sh
```

- scripts d’installation des programmes liés au déploiement

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |gitlab  | `./gitlab_install.sh` | v-1.0.0 | [todo] |
    |jenkins | `./jenkins_install.sh`| v-1.0.0 | [todo] |
    
---

```shell
./deploy.sh
```
- scripts d’aide au déploiement

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` | v-1.0.0 | [todo] |
    
---

```shell
./doc.sh
```
- scripts d’installation des programmes liés à la gestion de documentation

    |    NOM    |   SCRIPT  | VERSION | STATUT |
    |-----------|-----------|---------|--------|
    |bookstack  | `./bookstack_install.sh` | v-1.0.0 | [todo] |
    |wikijs     | `./wikijs_install.sh`    | v-1.0.0 | [todo] |
    |mediawiki  | `./mediawiki_install.sh` | v-1.0.0 | [todo] |
    |xwiki      | `./xwiki_install.sh`     | v-1.0.0 | [todo] |
    |docuwiki   | `./docuwiki_install.sh`  | v-1.0.0 | [todo] |
    |doxygene   | `./doxygene_install.sh`  | v-1.0.0 | [todo] |
    |phpDoc     | `./phpdoc_install.sh`    | v-1.0.0 | [todo] |
    |jsDoc      | `./jsdoc_install.sh`     | v-1.0.0 | [todo] |
    |docusaurus | `./docusaurus_install.sh`| v-1.0.0 | [todo] |
    
---

```shell
./project.sh
```
- scripts d’installation des programmes liés à la gestion de projet

    |     NOM    |   SCRIPT  | VERSION | STATUT |
    |------------|-----------|---------|--------|
    |open project| `./openproject_install.sh`| v-1.0.0 | [todo] |
    |leantime    | `./leantime_install.sh`   | v-1.0.0 | [todo] |
    |wekan       | `./wekan_install.sh`      | v-1.0.0 | [todo] |
    |taiga       | `./taiga_install.sh`      | v-1.0.0 | [todo] |
    |focalboard  | `./focalboard_install.sh` | v-1.0.0 | [todo] |
    
---

```shell
./archiving.sh
```

- scripts d’installation des programmes liés à l’archivage

    |    NOM  |   SCRIPT  | VERSION | STATUT |
    |---------|-----------|---------|--------|
    |nextcloud| `./nextcloud_install.sh`| v-1.0.0 | [todo] |
    
---

```shell
./access.sh
```

- scripts d’installation des programmes liés à la gestion des accès

    |     NOM    |   SCRIPT  | VERSION | STATUT |
    |------------|-----------|---------|--------|
    |open ldap   | `./openldap_install.sh`  | v-1.0.0 | [todo] |
    |super tokens| `./supetokens_install.sh`| v-1.0.0 | [todo] |
    |keycloak    | `./keycloak_install.sh`  | v-1.0.0 | [todo] |
    
---

```shell
./office.sh
```
- scripts d’installation des programmes de bureautique

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |open ldap   | `./openldap_install.sh`  | v-1.0.0 | [todo] |
    
---

```shell
./software.sh
```

- scripts d’installation de logiciel

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |chromium| `./chromium_install.sh`  | v-1.0.0 | [todo] |
    |penpot  | `./penpot_install.sh`    | v-1.0.0 | [todo] |
    
---

```shell
./utils.sh
```

- scripts d’installation de programme utilitaires

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---


### SCRIPTS PAR RÔLES
---

```shell
./developper.sh
```

- scripts d’installation d’utilitaire pour les développeurs

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

```shell
./ops.sh
```

- scripts d’installation d’utilitaire pour les opérateurs

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

```shell
./support.sh
```

- scripts d’installation d’utilitaire pour les équipes support

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

```shell
./po.sh
```

- scripts d’installation d’utilitaire pour product owner

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

```shell
./project_manager.sh
```

- scripts d’installation d’utilitaire pour les Chef de Projet

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

```shell
./marketing.sh
```

- scripts d’installation d’utilitaire pour les équipes marketing

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

```shell
./manager.sh
```

- scripts d’installation d’utilitaire pour les managers

    |   NOM  |   SCRIPT  | VERSION | STATUT |
    |--------|-----------|---------|--------|
    |    -   | `./xx.sh` |    -    |    -   |
    
---

## DOSSIER TEMPLATE
---

Le dossier `_template` facilite la mise en place de script en fournissant des modèles et des snippets de code.

> _template
>>    - 
>>      - ----> `./tpl_install.sh`
>>      - ----> `./tpl_install.fun.sh`
>>      - ----> `./tpl_call_function.sh`
>>      - ----> `./tpl_form.sh`
>>      - ----> `./tpl_selector.sh`
>> - data
>>>  - ----> fichier de configuration ou d'instalation

---
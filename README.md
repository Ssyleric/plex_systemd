### 📄 Plex Media Server (protection du service systemd)

#### 🎯 Objectif

Conserver **les mises à jour automatiques** du paquet `plexmediaserver` **tout en garantissant que le service reste fonctionnel** même si son fichier `systemd` est supprimé ou réinitialisé lors d’une mise à jour.

---

#### ⚠️ Problème rencontré

- Après un `apt update && apt full-upgrade`, Plex ne démarre plus.
- Le fichier `/etc/systemd/system/plexmediaserver.service` avait été supprimé ou n’était plus valide.
- Résultat : `systemctl status plexmediaserver` retournait une erreur de configuration (`bad-setting`).

---

#### ✅ Solution appliquée : override systemd

Systemd permet de créer un fichier `override.conf` pour **personnaliser et pérenniser la configuration d’un service** sans modifier les fichiers du paquet.

---

#### 🔧 Étapes réalisées

1. **Création d’un override persistent :**

```bash
systemctl edit plexmediaserver
```

Puis contenu ajouté dans `override.conf` :

```ini
[Service]
ExecStart=
ExecStart=/usr/lib/plexmediaserver/Plex Media Server
Environment="PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application Support"
User=plex
Group=plex
Restart=on-failure
TimeoutStopSec=20
```

> ✅ La directive `ExecStart=` vide annule celle du fichier d'origine, puis la vraie commande est redéfinie juste après.

---

2. **Recharge de systemd :**

```bash
systemctl daemon-reexec
systemctl daemon-reload
systemctl restart plexmediaserver
```

---

#### ✅ Résultat

- Plex fonctionne normalement ✅
- Le service `plexmediaserver` est désormais **protégé contre toute modification de paquet `apt`** ✅
- Les mises à jour futures du paquet `plexmediaserver` **sont conservées** (aucun `apt-mark hold`) ✅

---

#### 📌 Fichier override créé ici :

```
/etc/systemd/system/plexmediaserver.service.d/override.conf
```

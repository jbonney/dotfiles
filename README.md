# dotfiles

This repository simply stores relevant dotfiles so that they can easily be shared / imported across machines.
All of this is handled using [chezmoi](https://www.chezmoi.io/).

## Quick getting started guide

### Add a file / folder to chezmoi

To add a file from the `.config` folder, simply use:

```bash
chezmoi add ~/.config/file.ext
```

### Handle secure notes stored in Bitwarden

1. Manually create a new secure note in Bitwarden. Give it a name easy to query (for this example assume the name of the note is "chezmoi").
2. Log in to the Bitwarden CLI and sync the vault:
```bash
bw login <email-address>
bw unlock
export BW_SESSION="<SESSION-ID>"
bw sync
```
3. Find the new secure note ID
```bash
bw list items --search "chezmoi"
```
The note details will be displayed in the console. Copy the `id` value. 
```
[{"passwordHistory":null,"revisionDate":"2025-06-16T19:15:50.506Z","creationDate":"2025-06-16T19:15:50.506Z","deletedDate":null,"object":"item","id":"934a6f32-8sf8-5b8e-ae32-b2fe013duukk","organizationId":null,"folderId":"78ea9c0d-923d-293f-1020-a9e93028217c","type":2,"reprompt":0,"name":"chezmoi","notes":"This is the content of the private note","favorite":false,"secureNote":{"type":0},"collectionIds":[]}]
```
4. Create a new chezmoi template
```
chezmoi cd
touch dot_config/app/file.ext.tmpl
```
5. Edit the template with your favorite editor and add the following content
```
{{ (bitwarden "item" "934a6f32-8sf8-5b8e-ae32-b2fe013duukk").notes }}
```
6. Check the results and apply the changes
```
chezmoi diff
chezmoi apply
```
7. The new file `.config/app/file.ext` will be created with the content of the secure note saved in Bitwarden.
8. Add the newly created file to your chezmoi files
```
chezmoi add ~/.config/app/file.ext
```
chezmoi will detect that there is already a template for this file and ask whether you want to overwrite it. Just answer no and then proceed as usual (i.e. `git add .`, `git commit -m '...'`, `git push`).

An alternative is to prepopulate the content of the note from an existing file. This is for instance what is done in this [article](https.77dev.to7jmc2657using-bitwarden-and-chezmoi-to-manage-ssh-keys-5hfm) or in this [one](https://medium.com/@josemrivera/share-credentials-across-machines-using-chezmoi-and-bitwarden-4069dcb6e367).

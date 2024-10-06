A collection of custom Kismet Blocks for sequences in Mass Effect Legendary Edition.

## Adding blocks to Sequence Editor
With ![Legendary Explorer](https://github.com/ME3Tweaks/LegendaryExplorer), open the *Sequence Editor*. On the top left of the editor, open the *Experiments* tab, select *Load Custom Sequence Objects from Package*, and find the downloaded LEXGameContent.pcc's. They can then be found in the *Sequence Object Toolbox*.

This needs to be repeated every new Legendary Explorer session.


## LE1 Blocks
#### SFXSeqCond_GetPlayerClass
- Checks Player Pawns Class (Adept, Vanguard, etc), and activates the corresponding output.
#### SFXSeqCond_IsDLCInstalled
- Checks if a DLC is installed by finding its tlk.
#### SFXSeqAct_SetPawnAppearance
- Changes a BioPawns Meshes, Materials, and Material Parameters.
    - Material Parameters will be applied to all skeletal components; it's not limited to new meshes.
#### SFXSeqAct_SetPawnMaterials
- Targets a BioPawns Components and changes its Materials.
#### SFXSeqAct_SetPawnMaterialParameters
- Changes a BioPawns Vector, Scalar, and Texture Parameters.
    - Can either target a BioPawns Component or if the enum is "None", applies to all.
    
## LE2 Blocks
#### SFXSeqCond_GetPlayerClass
- Checks Player Pawns Class (Adept, Vanguard, etc), and activates the corresponding output.
#### SFXSeqAct_FindWeaponClass
- Finds Weapon Classes with a SeekFree path rather than requiring it in the package.
#### SFXSeqAct_FindImage
- Finds Textures with a SeekFree path rather than requiring it in the package.
    - Optimally for menu sequences.
    
## LE3 Blocks
#### SFXSeqCond_GetPlayerClass
- Checks Player Pawns Class (Adept, Vanguard, etc), and activates the corresponding output.


  

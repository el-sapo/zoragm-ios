# zoragm-ios

This project uses ZORA API to query blockchain information. 
https://docs.zora.co/

It includes some sample queries and Apollo integration setup for the communication with the API. 
To add more queries you simply need to add queries to the existing .graphql files or create new ones. Apollo will automatically read the queries and generate the swift code to interact with the API. 

The code to connect to the ZORA API is inside the ZO folder, there you will find:
- ZONetwork file that shows examples of how to fetch the data from the ZORA API. It has access to the queries created in your .graphql files and whre you can do your customizations.
- ZOHelper file where it includes an example of how to do your custom parsing of returned types (Apollo's Json parser fails for certain types)

It is common to have ipfs and svg images as part of the metadata for your NFTs, so I also included some basic code in CustomCells to load the different image types.

Installation:

The project uses COCOAPODS to install dependencies.
https://guides.cocoapods.org/using/getting-started.html

Once you set up cocoapods (and run pod install) open the workspace and you should be all set to run the project

Dependencies that are included:
- Apollo: https://github.com/apollographql/apollo-ios
- SDWebImage: https://github.com/SDWebImage/SDWebImage
- ProgressHUD: https://github.com/relatedcode/ProgressHUD

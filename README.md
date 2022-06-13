# zoragm-ios

For Web3 to gain adoption both for users and builders, apps user interface and experience needs to evolve into more rich, intuitive and customized solutions. Building native apps is a great way to get the most out of devices capabilities and resources to create personalized experiences. I created this project to show other builders how easy it is to integrate your apps with web3 content (thanks Zora for this API!) and not feel overwhelmed by the steep learning curve to start developing web3 apps. Mobile native experiences will become very important when it comes to NFT gaming and metaverse applications.

This project is a quickstart with sample code and tools to use ZORA API to query blockchain information for native iOS apps. 
https://docs.zora.co/

![zoragm](https://user-images.githubusercontent.com/104182252/173267051-6c53e5a6-a772-4fd6-abe8-2526527f54f7.gif)

[will update with appstore link once it finishes review process by apple]

It includes some sample queries (get wallet NFTs and get top collections) and Apollo GraphQL integration setup for the communication with the Zora API. 
To add more queries you simply need to add them to the existing .graphql files or create new files. As long as the files have the .graphql extension, Apollo will automatically read the queries and generate the swift code on every build run, so that you can integrate then with the api using native SWIFT code. 

The code to connect to the ZORA API is inside the ZO folder, there you will find:
- ZONetwork file that shows examples of how to fetch the data from the ZORA API and process. It has access to the queries created in your .graphql files and where you can do your customizations.
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

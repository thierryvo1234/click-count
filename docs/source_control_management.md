# Source Control Management

Source Control Management is an important component in our continuous integration and continous deployment pipeline.

It is a huge part of the software development workflow on a daily basis:
- Any code evolves by the developers can be tracked in Source Control Management.
- The developers will use the Source Control Management to track their changes separately (via their branches) and merge them all.

Any automation parts which needs to interact with the source code will use the Source Control Management:
- The continuous integration will obtain the code from the Source Control Management
- The Source Control Management will notify the Server of Continuous integration when the code needed to be built.

Especially, I used Git and Github to manage the source code and the versioning.

Some Git commands:
- To create a new branch:
```console
$ git checkout -b new_feature
```

- To create a pull request:
```console
$ git add web/new_feature.py
$ git commit -m "new_feature"
$ git push origin new_feature

```

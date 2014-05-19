CUSFileStorage
==============

A simple IOS file storage system using CUSSerializer achieve automatic support recursive model storage

![image](https://github.com/JJMM/CUSResources/raw/master/CUSFileStorage1.jpg)
![image](https://github.com/JJMM/CUSResources/raw/master/CUSFileStorage2.jpg)
## How To Get Started
1.Copy the folder named CUSFileStorage to your project
2.Copy the folder named CUSSerializer to your project.You can new version from git(https://github.com/JJMM/CUSSerializer)

## Start
### Us like NSMutableDictionary
```objective-c
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage];
    [storage setObject:@"value" forKey:@"key01"];
```
```objective-c
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage];
    NSString *value = [storage objectForKey:@"key01"];
```
### Support direct access model
```objective-c
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage];
    CUSStudent *model = [[CUSStudent alloc]init];
    [storage setObject:model forKey:@"key01"];
```
```objective-c
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage];
    CUSStudent *model = [storage objectForKey:@"key01"];
```

## License
CUSSerializer is licensed under the terms of the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html). Please see the [LICENSE](LICENSE) file for full details.

## Contributions

Contributions are totally welcome. We'll review all pull requests and if you send us a good one/are interested we're happy to give you push access to the repo. Or, you know, you could just come work with us.<br>

Please pay attention to add Star, your support is my greatest motivation, thank you.
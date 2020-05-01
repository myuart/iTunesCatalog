# iTunesCatalog
This app lets users enter a search term then calls the iTunes API to fetch from all media types that matches the search term.

## Notes
1. Among all the media types, "audiobook" returns a json format different from the others. Therefore, Codable cannot be used, instead specific parsing is implemented.
2. The newest Swift 5 Result Type is used in asynchronous API calls in this app. An URLSession extension is added to achieve this.
3. An extension of UIImageView is implemented to make an asynchronous urlSession.dataTask call to download the artwork image. NSCache is used to cache the downloaded image, so no repeating downloads.
4. The users can make a search result favorite. Each favorite is saved in the cache. 
5. Tapping on the url link of a search result (entry) will bring out Safari to display the details of the selected entry in iTunes. For some reason, Safari cannot display the "audiobook" and "podcast" url.

## License

The MIT License (MIT)

Copyright (c) [2020] [Maria Yu]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


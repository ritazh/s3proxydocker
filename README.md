Build
-----
`make build`

Run
---
`docker run -t -i -p 8080:8080 s3proxy`

If you cannot get to the internet from the container, use the following:
`docker run --dns 8.8.8.8 -t -i -p 8080:8080 s3proxy`
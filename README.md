# Techno Serve

[](https://github.com/commutatus/techno-serve-be/blob/main/README.md)

This project is built via Ruby on Rails and helps Techno Serve to manage its admin panel and its API.

---

**Platform Architecture**

- The platform implements a public GraphQL API.
- Authentication is managed via an access_token which is sent as an Authorization Header.
- User Interfaces consumes the GraphQL API
- The admin panel of the project is built on CM Admin, which is a gem managed by Commutatus

---

**Tech Stack**

- Ruby on Rails

---

**System Requirements**

- [Ruby](https://www.ruby-lang.org/en/downloads/) version **3.3.0** or above.
- [Imagemagick](https://imagemagick.org/) for image processing

---

**Third Party Tools**

- [Postmark](https://postmarkapp.com/) for transactional emails.
- [AWS S3](https://aws.amazon.com/s3/) for Storage

---

**Deployment**

- Deployments are triggered to Hatbox via an their "Automated Deployment" feature

---

**Credentials**

- Postmark API Key
- AWS Access Key & Secret
- Airbrake Project Key
- Scout APM key

---

**Running locally**

- To run this project in localhost, do the following:
  - `bundle install`
  - `rails db:setup`
  - `rails s`
- To seed the database run `rails db:seed`

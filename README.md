# Checkout

This code is an implementation of a checkout system that
has promotion rules.

Some important notes before reviewing:

1. I have committed in stages to allow you to see how I work.
   Starting off with things being built by factory bot into
   fake classes, then as the implementation needed real
   classes they were added and used by factory bot as well.
2. There is no user interface (lack of time) but an integration
   spec can be found in spec/integration/checkout_spec.rb.
   (Note, the very last context in here uses the test data
   provided in the initial specification)
   Note that all monetary values are stored as integers (
   representing the base unit - i.e. pence - along with a
   currency identifier).
   The conversion to £10.00 for example is expected to be
   done in the front end.
3. As little is known about the application that this code
   would sit in, no framework has been used and plain ruby
   objects used to represent the data.  If active record
   were to be used instead, this should be an easy change.
   This allowed me to focus on the business logic without
   worrying about setting up things like activerecord along
   with a database.
4. Test coverage is 97%
5. Whilst inheritance could have been used in the
   promotion rules, it was felt that not enough
   was known about future promotion types and
   it felt like premature optimisation.


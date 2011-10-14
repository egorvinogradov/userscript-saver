describe('IocContainer', function() {
  var iocContainer;
  iocContainer = null;
  beforeEach(function() {
    return iocContainer = new IocContainer;
  });
  it('creates new object if its constructor given in \'ctor\'', function() {
    var Foo;
    Foo = (function() {
      function Foo() {
        this.name = 'foo';
      }
      return Foo;
    })();
    iocContainer.setSchema({
      fooInstance: {
        ctor: Foo
      }
    });
    return expect(iocContainer.getElement('fooInstance')).toEqual(new Foo);
  });
  it('gets existing object if its reference given in \'reference\'', function() {
    var foo;
    foo = {
      name: 'fooElement'
    };
    iocContainer.setSchema({
      fooInstance: {
        ref: foo
      }
    });
    return expect(iocContainer.getElement('fooInstance')).toBe(foo);
  });
  it('checks that schema is set and contains element', function() {
    var getFoo;
    getFoo = function() {
      return iocContainer.getElement('fooInstance');
    };
    expect(getFoo).toThrow('Dependency schema is not set');
    iocContainer.setSchema({});
    return expect(getFoo).toThrow('Element \'fooInstance\' not found in dependency schema');
  });
  it('returns the same element again for the same name', function() {
    var fooInstance;
    iocContainer.setSchema({
      fooInstance: {
        ctor: function() {}
      }
    });
    fooInstance = iocContainer.getElement('fooInstance');
    return expect(iocContainer.getElement('fooInstance')).toBe(fooInstance);
  });
  return it('sets element dependencies', function() {
    var fooInstance;
    iocContainer.setSchema({
      fooInstance: {
        ctor: function() {},
        deps: {
          '_barProperty': 'barInstance'
        }
      },
      barInstance: {
        ctor: function() {}
      }
    });
    fooInstance = iocContainer.getElement('fooInstance');
    return expect(fooInstance._barProperty).toBe(iocContainer.getElement('barInstance'));
  });
});
require 'syma/mental_model'

class Syma
  describe MentalModel do
    describe '#method_missing' do
      it 'returns a Collection' do
        subject.foo.should be_kind_of(MentalModel::Collection)
      end

      it 'returns different Collections for different messages' do
        subject.foo.should_not === subject.bar
      end
    end

    describe MentalModel::Collection do
      let(:collection) { MentalModel::Collection.new('widgets') }

      describe '#values_at' do
        it 'returns an array of items matching the specified keys' do
          collection[:foo] = 'foo'
          collection[:bar] = 'bar'
          collection[:baz] = 'baz'
          collection.values_at(:foo, :baz).should == %w(foo baz)
        end
      end

      describe '#slice' do
        it 'returns a hash of items from the collection that match the specified keys' do
          collection[:foo] = 'foo'
          collection[:bar] = 'bar'
          collection[:baz] = 'baz'
          collection.slice(:foo, :baz).should == {:foo => 'foo', :baz => 'baz'}
        end
      end

      describe '#except' do
        it 'returns a hash of items from the collection that do not match the specified keys' do
          collection[:foo] = 'foo'
          collection[:bar] = 'bar'
          collection[:baz] = 'baz'
          collection[:yak] = 'yak'
          collection.except(:foo, :baz).should == {:bar => 'bar', :yak => 'yak'}
        end
      end

      describe '#delete' do
        it 'deletes and returns the item matching the specified key' do
          collection[:baz] = 'baz'
          collection.delete(:baz).should == 'baz'
          lambda { collection[:baz] }.should raise_error(UnknownKeyError)
        end

        it 'persists the deleted key/value pair to the #deleted subcollection' do
          collection[:baz] = 'baz'
          collection.delete(:baz)
          collection.deleted[:baz].should == 'baz'
        end

        it 'raises a UnknownKeyError exception if trying to delete a missing key' do
          lambda { collection.delete(:snerf) }.should \
            raise_error(UnknownKeyError, "Can't find mental_model.widgets[:snerf]. Did you forget to set it?")
        end
      end

      describe '#delete_if' do
        before(:each) do
          collection[:foo] = 'foo'
          collection[:bar] = 'spoon'
          collection[:baz] = 'baz'
        end

        it 'deletes all members of collection for whom given block evaluates to false' do
          collection.delete_if { |k,v| k.to_s != v }
          collection.keys.should =~ [:foo, :baz]
        end

        it 'adds deleted members of collection to #deleted subcollection' do
          collection.delete_if { |k,v| k.to_s != v }
          collection.deleted.keys.should == [:bar]
        end

        it 'returns hash of items not deleted' do
          collection.delete_if { |k,v| k.to_s != v }.should == { :foo => 'foo', :baz => 'baz' }
        end
      end

      describe '#deleted' do
        it 'generates a new subcollection if none exists' do
          initialized_collection = collection
          MentalModel::Collection.should_receive(:new).with("deleted")
          initialized_collection.deleted
        end

        it 'returns the deleted subcollection if already initialized' do
          deleted_collection = collection.deleted
          collection.deleted.should === deleted_collection
        end
      end

      it 'raises a UnknownKeyError exception for #[] with a missing key' do
        lambda { collection[:foo] }.should \
          raise_error(UnknownKeyError, "Can't find mental_model.widgets[:foo]. Did you forget to set it?")
      end

      describe '#dup' do
        it 'returns a different object' do
          new_collection = collection.dup
          new_collection.__id__.should_not === collection.__id__
        end

        it 'returns an object with equal values to the original' do
          collection[:foo] = :bar
          collection[:baz] = :bam
          new_collection = collection.dup
          new_collection[:foo].should == :bar
          new_collection[:baz].should == :bam
        end

        it 'is a deep copy' do
          collection[:foo] = {:bar => 'baz'}
          new_collection = collection.dup
          new_collection[:foo][:bar].should == 'baz'
          new_collection[:foo][:bar].__id__.should_not === collection[:foo][:bar].__id__
        end
      end
    end
  end
end

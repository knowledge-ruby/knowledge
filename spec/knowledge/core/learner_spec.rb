# frozen_string_literal: true

RSpec.describe Knowledge::Core::Learner do
  subject(:learner) { described_class.new(source_type: source_type, variables: variables, setter: setter) }

  let(:source_type) { :hash_data }
  let(:variables) { {} }
  let(:setter) { :default_setter }

  describe '#initialize' do
    context 'with class arguments' do
      let(:source_type) { Class }
      let(:setter) { Class }

      it 'camelizes source_type' do
        expect(learner.instance_variable_get(:@source)).to eq source_type
      end

      it 'sets variables' do
        expect(learner.instance_variable_get(:@variables)).to eq variables
      end

      it 'camelizes setter' do
        expect(learner.instance_variable_get(:@setter)).to eq setter
      end
    end

    context 'with string arguments' do
      it 'camelizes source_type' do
        expect(learner.instance_variable_get(:@source)).to eq 'HashData'
      end

      it 'sets variables' do
        expect(learner.instance_variable_get(:@variables)).to eq variables
      end

      it 'camelizes setter' do
        expect(learner.instance_variable_get(:@setter)).to eq 'DefaultSetter'
      end
    end
  end

  describe '#call' do
    let(:getter_class) { double('getter_class', new: getter_instance) }
    let(:getter_instance) { instance_double('getter_instance', call: getter_data) }
    let(:getter_callable) { true }
    let(:getter_data) { { getter: :data } }

    let(:setter_class) { double('setter_class', new: setter_instance) }
    let(:setter_instance) { instance_double('setter_instance', call: getter_data) }
    let(:setter_callable) { true }

    before do
      allow(getter_class).to receive(:is_a?).with(Class).and_return(true)
      allow(getter_instance).to receive(:respond_to?).with(:call).and_return(getter_callable)

      allow(setter_class).to receive(:is_a?).with(Class).and_return(true)
      allow(setter_instance).to receive(:respond_to?).with(:call).and_return(setter_callable)
    end

    context 'when there is an error with the getter' do
      context 'when getter class cannot be resolved' do
        before { allow(Knowledge::Getters).to receive(:const_get).and_raise(NameError) }

        it 'raises Knowledge::UnknownGetter' do
          expect { learner.call }.to raise_error(Knowledge::UnknownGetter)
        end
      end

      context 'when resolved getter is not a class' do
        before { allow(Knowledge::Getters).to receive(:const_get).and_return(Module.new) }

        it 'raises Knowledge::UnknownGetter' do
          expect { learner.call }.to raise_error(Knowledge::UnknownGetter)
        end
      end

      context 'when resolved getter does not implement #call' do
        let(:getter_callable) { false }

        before { allow(Knowledge::Getters).to receive(:const_get).and_return(getter_class) }

        it 'raises Knowledge::NotCallable' do
          expect { learner.call }.to raise_error(Knowledge::NotCallable)
        end
      end
    end

    context 'when getter is successfully resolved' do
      before { allow(Knowledge::Getters).to receive(:const_get).and_return(getter_class) }

      context 'when there is an error with the setter' do
        context 'when setter class cannot be resolved' do
          before { allow(Knowledge::Setters).to receive(:const_get).and_raise(NameError) }

          it 'raises Knowledge::UnknownSetter' do
            expect { learner.call }.to raise_error(Knowledge::UnknownSetter)
          end
        end

        context 'when resolved setter is not a class' do
          before { allow(Knowledge::Setters).to receive(:const_get).and_return(Module.new) }

          it 'raises Knowledge::UnknownSetter' do
            expect { learner.call }.to raise_error(Knowledge::UnknownSetter)
          end
        end

        context 'when resolved setter does not implement #call' do
          let(:setter_callable) { false }

          before { allow(Knowledge::Setters).to receive(:const_get).and_return(setter_class) }

          it 'raises Knowledge::NotCallable' do
            expect { learner.call }.to raise_error(Knowledge::NotCallable)
          end
        end
      end

      context 'when setter is successfully resolved' do
        before do
          allow(Knowledge::Setters).to receive(:const_get).and_return(setter_class)

          learner.call
        end

        it 'instanciates the getter passing the variables' do
          expect(getter_class).to have_received(:new).with(variables)
        end

        it 'calls the getter' do
          expect(getter_instance).to have_received(:call)
        end

        it 'instanciates the setter passing data from getter' do
          expect(setter_class).to have_received(:new).with(data: getter_data)
        end

        it 'calls the getter' do
          expect(setter_instance).to have_received(:call)
        end
      end
    end
  end
end

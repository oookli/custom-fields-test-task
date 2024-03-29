# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCustomField, type: :model do
  let(:name) { 'some test name' }
  let(:type) { :number }
  let(:user_custom_field) { create(:user_custom_field, name:, field_type: type) }

  it 'is valid' do
    expect(user_custom_field).to be_valid
  end

  it 'generates correct internal_name' do
    expect(user_custom_field.internal_name).to eq 'some_test_name'
  end

  context 'when options is provided' do
    it 'raises record invalid error' do
      expect { create(:user_custom_field, name:, field_type: type, options: %w[test1 test2]) }.to raise_error(
        ActiveRecord::RecordInvalid, /Options must be blank/
      )
    end
  end

  context 'when field type is dropdown' do
    let(:user_custom_field) { create(:user_custom_field, name:, field_type: :dropdown, options: %w[test1 test2]) }

    it 'is valid' do
      expect(user_custom_field).to be_valid
    end

    context 'when options is not set' do
      let(:user_custom_field) { build(:user_custom_field, name:, field_type: :dropdown) }

      before { user_custom_field.validate }

      it 'is not valid' do
        expect(user_custom_field).not_to be_valid
      end

      it 'raises validation failed' do
        expect(user_custom_field.errors.full_messages).to include(match('Options can\'t be blank'))
      end
    end

    context 'when options is not valid' do
      let(:user_custom_field) { build(:user_custom_field, name:, field_type: :dropdown, options: 'test') }

      before { user_custom_field.validate }

      it 'is not valid' do
        expect(user_custom_field).not_to be_valid
      end
    end
  end

  context 'when field type is multi_dropdown' do
    let(:user_custom_field) { create(:user_custom_field, name:, field_type: :multi_dropdown, options: %w[test1 test2]) }

    it 'is valid' do
      expect(user_custom_field).to be_valid
    end

    context 'when options is not set' do
      let(:user_custom_field) { build(:user_custom_field, name:, field_type: :multi_dropdown) }

      before { user_custom_field.validate }

      it 'is not valid' do
        expect(user_custom_field).not_to be_valid
      end

      it 'raises validation failed' do
        expect(user_custom_field.errors.full_messages).to include(match('Options can\'t be blank'))
      end
    end

    context 'when options is not valid' do
      let(:user_custom_field) { build(:user_custom_field, name:, field_type: :multi_dropdown, options: 'test') }

      before { user_custom_field.validate }

      it 'is not valid' do
        expect(user_custom_field).not_to be_valid
      end
    end
  end

  context 'when field type is not correct' do
    let(:invalid_type) { :blabla }

    it 'raises record invalid error' do
      expect { create(:user_custom_field, field_type: invalid_type) }.to raise_error(
        ActiveRecord::RecordInvalid, /Field type is not included in the list/
      )
    end
  end

  context 'when name is not provided' do
    let(:user_custom_field) { build(:user_custom_field, name: nil) }

    before { user_custom_field.validate }

    it 'is not valid' do
      expect(user_custom_field).not_to be_valid
    end

    it 'raises internal_name error as well' do
      expect(user_custom_field.errors.full_messages).to include(match('Internal name can\'t be blank'))
    end
  end

  context 'when field_type is not provided' do
    let(:user_custom_field) { build(:user_custom_field, field_type: nil) }

    it 'is not valid' do
      expect(user_custom_field).not_to be_valid
    end
  end

  context 'when item with such a name exists' do
    let(:name) { 'some existed field' }

    let!(:user_custom_field) { create(:user_custom_field, name:) }

    it 'raises record not unique error' do
      expect { create(:user_custom_field, name:) }
        .to raise_error(ActiveRecord::RecordInvalid, /Name has already been taken/)
    end
  end
end

class MongoPatient
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  store_in collection: 'patient'

  field :patientSequenceNumber, type: String
  field :currentPatientStatus, type: String
  field :currentStepNumber, type: String
  field :patientRejoinTriggers, type: Array
  field :patientTriggers, type: Array
  field :priorDrugs, type: Array
end

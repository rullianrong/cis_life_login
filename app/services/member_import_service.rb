class MemberImportService
    def initialize(csv, cooperative)
        @csv = csv
        @cooperative = cooperative
    end


    def import_members
    # ! Attributes with Date type should have a format of: yyyy-mm-dd
    # Initialize variables to keep track of member imports
    created_members_counter = 0
    updated_members_counter = 0

    # Iterate over each row in the CSV file
    @csv.each do |row|
      # Extract member data from CSV row
      member_hash = {
        last_name: row["Last Name"].upcase,
        first_name: row["First Name"].upcase,
        middle_name: row["Middle Name"].upcase,
        suffix: row["Suffix"].upcase,
        birth_place: row["Birth Place"],
        birth_date: row["Birthdate"],
        gender: row["Gender"],
        address: row["Address"],
        sss_no: row["SSS #"],
        tin_no: row["TIN #"],
        mobile_number: row["Mobile #"],
        email: row["Email"],
        civil_status: row["Civil Status"],
        height: row["Height (cm)"],
        weight: row["Weight (kg)"],
        occupation: row["Occupation"],
        employer: row["Employer"],
        work_address: row["Work Address"],
        legal_spouse: row["Spouse"],
        work_phone_number: row["Work Phone #"]
      }

      # Extract cooperative member data from CSV row
      coop_member_hash = {
        cooperative_id: @cooperative.id,
        coop_branch_id: CoopBranch.find_by(name: row["Branch"]).id,
        membership_date: row["Membership Date"],
        transferred: row["Transferred?"].downcase == "yes"
      } 

      # Check if a member with the same first name, last name, and birth date already exists
      member = Member.find_or_initialize_by(
        first_name: member_hash[:first_name],
        last_name: member_hash[:last_name],
        birth_date: member_hash[:birth_date]
      )
            
      if member.persisted?
        # check if member is already a coop member
        coop_member = member.coop_members.find_or_initialize_by(cooperative_id: @cooperative.id) 
        member.update(member_hash)
        coop_member.update(coop_member_hash)
        updated_members_counter += 1
      else
        # If a member does not exist, create a new record
        new_member = Member.create(member_hash)
        new_coop_member = new_member.coop_members.create(coop_member_hash) if new_member.save!

        created_members_counter += 1 if new_coop_member.save!
      end
    end
    counters = {
        created_members_counter: created_members_counter,
        updated_members_counter: updated_members_counter
      }
end
end
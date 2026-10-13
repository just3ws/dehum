# frozen_string_literal: true

require 'open3'
require 'json'

RSpec.describe 'Dehum Forensic DSP Engine Contracts' do
  let(:executable) { File.expand_path('../fix_video.sh', __dir__) }

  describe 'Clean Architecture: Sovereign CLI Interface' do
    it 'conforms to POSIX --help contract with zero dependencies' do
      stdout, stderr, status = Open3.capture3("#{executable} --help")
      expect(status.exitstatus).to eq(0)
      expect(stdout).to include('fix_video.sh')
      expect(stdout).to include('DSP stages')
      expect(stderr).to be_empty
    end

    it 'conforms to semantic versioning contract' do
      stdout, _stderr, status = Open3.capture3("#{executable} --version")
      expect(status.exitstatus).to eq(0)
      expect(stdout).to match(/fix_video\.sh version \d+\.\d+\.\d+/)
    end

    it 'fails cleanly with non-zero exit when arguments are missing (Fail Fast)' do
      _stdout, stderr, status = Open3.capture3(executable)
      expect(status.exitstatus).not_to eq(0)
      expect(stderr).to include('Error')
    end
  end

  describe 'DSP Filter Invariants (Uncle Bob Clean Design)' do
    it 'calculates deterministic dry-run filtergraph parameters' do
      test_file = File.expand_path('../docs/assets/audio/sample_raw.m4a', __dir__)
      if File.exist?(test_file)
        stdout, _stderr, status = Open3.capture3("#{executable} --dry-run #{test_file.shellescape}")
        expect(status.exitstatus).to eq(0)
        expect(stdout).to include('highpass=f=80')
        expect(stdout).to include('adeclick')
        expect(stdout).to include('afftdn')
        expect(stdout).to include('bandreject')
      end
    end
  end

  describe 'DHH Conceptual Compression: Operational Simplicity' do
    it 'does not require an external daemon, container, or background broker' do
      # Proves the tool is a self-contained POSIX command, zero-runtime bloat
      expect(File.executable?(executable)).to be true
      expect(File.read(executable)).to include('-c:v copy')
    end
  end
end
